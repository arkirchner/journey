import { Controller } from 'stimulus';
import { DirectUpload } from '@rails/activestorage';
import { ajax, fire } from '@rails/ujs';
import morphdom from 'morphdom';
import qs from 'qs';
import ajaxToHtml from '../utils/ajax_to_html';

const ACTIVE_CLASS = 'drop-zone--active';
const ACTIVE_ITEM_CLASS = 'drop-zone__item--active';

class ImageUploader {
  constructor(direct_upload_path, unprocessed_image_path) {
    this.direct_upload_path = direct_upload_path;
    this.unprocessed_image_path = unprocessed_image_path;
    this.queue = [];
  }

  onUpdate(callback) {
    this.updateCallback = callback;
  }

  unUpdate() {
    this.updateCallback = null;
  }

  onUpload(callback) {
    this.uploadCallback = callback;
  }

  unUpload() {
    this.uploadCallback = null;
  }

  bulk_upload(files) {
    this.queue.push(...files.map(f => ({ file: f, uploaded: false })));
    this.pushUpdate();

    if (!this._uploading) {
      this.upload();
    }
  }

  upload() {
    const job = this.queue.filter(f => !f.uploaded)[0];
    const upload = new DirectUpload(job.file, this.direct_upload_path);

    upload.create((error, blob) => {
      if (error) {
        console.log(error);
      } else {
        ajax({
          url: this.unprocessed_image_path,
          type: 'POST',
          data: qs.stringify({
            unprocessed_image: { image: blob.signed_id },
          }),
          success: (...data) => {
            if (this.uploadCallback) {
              this.uploadCallback(ajaxToHtml(data));
            }
            upload.uploaded = true;
            this.pushUpdate();
            this.upload();
          },
          error: error => {
            console.log('ajax upload error', error);
          },
        });
      }
    });
  }

  pushUpdate() {
    if (this.updateCallback) {
      this.updateCallback(this.queue);
    }
  }
}

export default class extends Controller {
  static targets = [
    'template',
    'uploads',
    'input',
    'fileInput',
    'form',
    'dropZone',
  ];

  initialize() {
    this.uploader = new ImageUploader(this.url, '/unprocessed_images');
  }

  connect() {
    this.uploader.onUpdate(this._renderUploadImage);
    this.uploader.onUpload(this._addUpload);
  }

  disconnect() {
    this.uploader.unUpdate();
    this.uploader.unUpload();
  }

  drop(event) {
    // Prevent default behavior (Prevent file from being opened)
    event.preventDefault();
    event.stopPropagation();

    this.dropZoneTarget.classList.remove(ACTIVE_CLASS);

    const files = Array.from(event.dataTransfer.items)
      .filter(item => item.kind === 'file')
      .map(item => item.getAsFile());

    this._storeFiles(files);
  }

  dragOver(event) {
    // Prevent default behavior (Prevent file from being opened)
    event.preventDefault();
  }

  dragEnter() {
    this.dropZoneTarget.classList.add(ACTIVE_CLASS);
  }

  dragLeave() {
    this.dropZoneTarget.classList.remove(ACTIVE_CLASS);
  }

  open(event) {
    event.preventDefault();
    event.stopPropagation();

    this.inputTarget.click();
  }

  save({ target }) {
    const files = Array.from(target.files);
    this.uploader.bulk_upload(files);
  }

  show({ detail: [_data, _status, { response }] }) {
    Array.from(this.dropZoneTarget.children)
      .filter(e => !e.classList.contains(ACTIVE_ITEM_CLASS))[0]
      .classList.add(ACTIVE_ITEM_CLASS);

    this.uploadsTarget.insertAdjacentHTML('afterbegin', response);

    if (this._files.length !== 0) {
      this._upload(this._files[0]);
    } else {
      this.uploading = false;
    }
  }

  _renderUploadImage = queue => {
    const template = this.templateTarget.innerHTML;
    const newDropZone = document.importNode(this.dropZoneTarget, true);
    newDropZone.innerHTML = queue
      .map(({ file, uploaded }) => {
        return template.replace(/IMAGE_URL/g, URL.createObjectURL(file));
      })
      .join('')
      .trim();

    morphdom(this.dropZoneTarget, newDropZone);
  };

  _addUpload = html => {
    console.log('----------------', html);
    // this.uploadsTarget.insertAdjacentHTML('afterbegin', html);
  };

  _storeFiles(files) {
    this._files = [...(this._files || []), ...files];

    const uploadElements = files
      .map(f =>
        this.templateTarget.innerHTML.replace(
          /IMAGE_URL/g,
          URL.createObjectURL(f)
        )
      )
      .join('')
      .trim();

    this.dropZoneTarget.insertAdjacentHTML('beforeend', uploadElements);
    this._startUpload();
  }

  _startUpload() {
    if (!this.uploading) {
      this._upload(this._files[0]);
    }
  }

  _upload(file) {
    this.uploading = true;
    const upload = new DirectUpload(file, this.url);

    upload.create((error, blob) => {
      if (error) {
        console.log(error);
      } else {
        this._files.shift();
        this.fileInputTarget.value = blob.signed_id;
        fire(this.formTarget, 'submit');
      }
    });
  }

  get templet() {
    return this.templateTarget.innerHTML;
  }

  get url() {
    return this.data.get('url');
  }
}

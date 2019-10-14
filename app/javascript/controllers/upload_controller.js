import { Controller } from 'stimulus';
import { DirectUpload } from '@rails/activestorage';
import { fire } from '@rails/ujs';

const ACTIVE_CLASS = 'drop-zone--active';
const ACTIVE_ITEM_CLASS = 'drop-zone__item--active';

export default class extends Controller {
  static targets = [
    'template',
    'uploads',
    'input',
    'fileInput',
    'form',
    'dropZone',
  ];

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
    this._storeFiles(files);
    target.file = [];
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

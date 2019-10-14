import { Controller } from 'stimulus';
import { DirectUpload } from '@rails/activestorage';
import { fire } from '@rails/ujs';

export default class extends Controller {
  static targets = [
    'template',
    'uploads',
    'input',
    'fileInput',
    'form',
    'dropZone',
  ];

  open(event) {
    this.inputTarget.click();
  }

  save({ target }) {
    const files = Array.from(target.files);
    this._files = [...(this._files || []), ...files];
    target.file = [];

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

  show({ detail: [_data, _status, { response }] }) {
    Array.from(this.dropZoneTarget.children)
      .filter(e => !e.classList.contains('drop-zone__item--active'))[0]
      .classList.add('drop-zone__item--active');

    this.uploadsTarget.insertAdjacentHTML('afterbegin', response);

    if (this._files.length !== 0) {
      this._upload(this._files[0]);
    } else {
      this.uploading = false;
    }
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

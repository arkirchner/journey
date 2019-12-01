import { DirectUpload } from '@rails/activestorage';
import { ajax } from '@rails/ujs';
import qs from 'qs';
import ajaxToHtml from './utils/ajax_to_html';

export default class ImageUploader {
  constructor(direct_upload_path, unprocessed_image_path) {
    this.direct_upload_path = direct_upload_path;
    this.unprocessed_image_path = unprocessed_image_path;
    this.queue = [];
  }

  onUpdate(callback) {
    this.callback = callback;
  }

  unUpdate() {
    this.callback = null;
  }

  bulk_upload(files) {
    this.queue.push(
      ...files.map(f => ({ id: this.newId(), file: f, uploaded: false }))
    );

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
            console.log('html', ajaxToHtml(data));
          },
          error: error => {
            console.log('ajax upload error', error);
          },
        });
      }
    });
  }

  pushUpdate() {
    if (this.callback) {
      this.callback(this.queue);
    }
  }

  newId() {
    this._id = (this.id || 0) + 1;
    return this._id;
  }
}

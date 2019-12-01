import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['list'];

  connect() {
    if (!this.list) {
      this.list = [];
    }

    console.log('ssss', Date.now());
    console.log('list', this.list);
  }

  submit() {
    this.list.push(Date.now());
    this.listTarget.insertAdjacentHTML('afterbegin', `<li>${Date.now()}</li>`);
  }
}

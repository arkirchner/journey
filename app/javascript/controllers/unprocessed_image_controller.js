import { Controller } from 'stimulus';
import { ajax } from '@rails/ujs';
import { Map, TileLayer, Marker, Icon } from 'leaflet';
import markerIcon from 'leaflet/dist/images/marker-icon.png';
import markerIcon2x from 'leaflet/dist/images/marker-icon-2x.png';
import markerShadow from 'leaflet/dist/images/marker-shadow.png';
import morphdom from 'morphdom';
import { open as openModal } from './modal_controller';
import ajaxToHtml from '../utils/ajax_to_html';

const icon = new Icon({
  iconUrl: markerIcon,
  iconRetinaUrl: markerIcon2x,
  shadowUrl: markerShadow,
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  tooltipAnchor: [16, -28],
  shadowSize: [41, 41],
});

export default class extends Controller {
  static targets = ['progress', 'map'];

  connect() {
    // this.state = 0;
    // this._update();
    // this.map = this._createMap();
    //
    this._refresh();
  }

  disconnect() {
    if (this._refreshTimer) {
      clearInterval(this._refreshTimer);
    }
  }

  get url() {
    return this.data.get('url');
  }

  get processing() {
    console.log('processing', this.data.get('processing'));
    return String(this.data.get('processing')) === 'true';
  }

  // _update = () => {
  //   this.state = this.state + 10;
  //   this._setState(this.state);

  //   if (this.state < 100) {
  //     setTimeout(this._update, 50);
  //   }
  // };

  edit(event) {
    openModal(ajaxToHtml(event));
  }

  _refresh() {
    if (this.processing) {
      this._refreshTimer = setInterval(() => {
        this._load();
      }, 3000);
    }
  }

  _load = () => {
    ajax({
      url: this.url,
      type: 'GET',
      success: (...data) => {
        if (this.processing) {
          morphdom(this.element, ajaxToHtml(data));

          if (this.processing) {
            clearInterval(this._refreshTimer);
          }
        }
      },
    });
  };

  // _setState(progress) {
  //   this.progressTarget.setAttribute('aria-valuenow', progress);
  //   this.progressTarget.setAttribute('style', `width: ${progress}%`);
  // }

  // _createMap() {
  //   const tileLayer = new TileLayer(
  //     'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  //     {
  //       attribution:
  //         '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
  //     }
  //   );

  //   const marker = new Marker([51.505, -0.09], { icon });

  //   return new Map(this.mapTarget, {
  //     center: [51.505, -0.09],
  //     zoom: 13,
  //     layers: [tileLayer, marker],
  //   });
  // }
}

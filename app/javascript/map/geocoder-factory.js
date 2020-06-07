import OpenStreetMapGeocoder from './geocoders/open-street-map-geocoder';
import YandexGeocoder from './geocoders/yandex-geocoder';

export default class GeocoderFactory {

  /**
   * Types of geocoders that are available to create.
   */
  static TYPES = {
    openStreetMap: 'openStreetMap',
    yandex: 'yandex'
  }

  /**
   * Factory method to create geocoder instance.
   * @param {String} type Type of geocoder.
   * @returns {Geocoder} Geocoder instance.
   */
  static createGeocoder(type) {
    switch (type) {
      case this.TYPES.yandex:
        return new YandexGeocoder();
      case this.TYPES.openStreetMap:
      default:
        return new OpenStreetMapGeocoder();
    }
  }
}

import OpenStreetMapGeocoder from './open-street-map-geocoder';

export default class GeocoderFactory {

  /**
   * Types of geocoders that are available to create.
   */
  static TYPES = {
    openStreetMap: 'openStreetMap'
  }

  /**
   * Factory method to create geocoder instance.
   * @param {String} type Type of geocoder.
   * @returns {Geocoder} Geocoder instance.
   */
  static createGeocoder(type) {
    switch (type) {
      case this.TYPES.openStreetMap:
      default:
        return new OpenStreetMapGeocoder();
    }
  }
}

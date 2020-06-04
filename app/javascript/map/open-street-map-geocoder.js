import BaseGeocoder from './empty-geocoder';
import { OpenStreetMapProvider } from 'leaflet-geosearch';

export default class OpenStreetMapGeocoder extends BaseGeocoder {
  constructor() {
    super();
    this.provider = new OpenStreetMapProvider();
  }

  /**
   * Finds point by address.
   * @param {String} address Address to search.
   * @returns {Promise} Promise
   */
  findByAddress(address) {
    return this.provider.search({ query: address });
  }
}

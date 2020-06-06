import BaseGeocoder from '../base-geocoder';
import { OpenStreetMapProvider } from 'leaflet-geosearch';
import Point from '../point';

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
  async findByAddress(address) {
    const data = await this.provider.search({ query: address });

    return this.normalizePoints(data);
  }

  /**
   * Normalizes points.
   * @param {Any} data Data.
   * @returns {Array} Normalized points.
   */
  // eslint-disable-next-line class-methods-use-this
  normalizePoints(data) {
    return data.map(point => new Point(point.x, point.y, point.label));
  }
}

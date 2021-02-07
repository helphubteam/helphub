/* eslint-disable no-ternary */
/* eslint-disable multiline-ternary */
/* eslint-disable-next-line no-ternary */
import BaseGeocoder from '../base-geocoder';
import Point from '../point';

export default class YandexGeocoder extends BaseGeocoder {

  /**
   * Finds point by address.
   * @param {String} address Address to search.
   * @returns {Promise} Promise
   */
  // eslint-disable-next-line max-statements
  async findByAddress(address) {
    let requestString = 'https://geocode-maps.yandex.ru/1.x?';
    const options = {
      apikey: '479be894-c949-490f-9cb1-aa6528b652f2',
      format: 'json'
    };
    options.geocode = address;

    requestString += Object.entries(options).
      map(([key, value]) => `${key}=${Array.isArray(value) ? value.join(',') : value}`).
      join('&');

    const response = await fetch(requestString);
    let points = null;

    if (response.ok) {
      const responseContent = await response.json();
      points = this.normalizePoints(responseContent);
    } else {
      // eslint-disable-next-line no-warning-comments
      // ToDo: replace this method when logging service will be implemented.
      console.log(response);
    }

    return points;
  }

  /**
   * Normalizes points.
   * @param {Any} data Data.
   * @returns {Array} Normalized points.
   */
  // eslint-disable-next-line class-methods-use-this
  normalizePoints(data) {
    const geoObjects = data.response.GeoObjectCollection.featureMember;

    return Object.values(geoObjects).
      map(value => {
        const geoObject = value.GeoObject;
        const [lon, lat] = geoObject.Point.pos.split(' ');

        return new Point(lat, lon, `${geoObject.name}, ${geoObject.description}`)
      });
  }
}

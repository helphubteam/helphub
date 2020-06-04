/* eslint-disable class-methods-use-this */
/* eslint-disable no-unused-vars */
export default class BaseGeocoder {

  /**
   * Finds point by address.
   * @param {String} address Address to search.
   * @returns {Promise} Promise
   */
  findByAddress(address) {
    throw new Error('Method findByAddress is not implemented in BaseGeocoder class');
  }
}


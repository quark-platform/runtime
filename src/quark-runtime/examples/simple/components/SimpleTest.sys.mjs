/* vim:set ts=2 sw=2 sts=2 et cin: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//@ts-check
///<reference types="gecko-types" />

export class SimpleTest {
  classID = Components.ID('{f2f71d91-0451-47ec-aaa0-166663a7711a}')
  QueryInterface = ChromeUtils.generateQI(['nsISimpleTest'])

  /**
   * @param {number} a
   * @param {number} b
   * @returns {number}
   */
  add(a, b) {
    console.log(`add(${a},${b}) from JS`)
    return a + b
  }
}

/* vim:set ts=2 sw=2 sts=2 et cin: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

Components.utils.import('resource://gre/modules/XPCOMUtils.jsm')

function SimpleTest() {}

SimpleTest.prototype = {
  classID: Components.ID('{f2f71d91-0451-47ec-aaa0-166663a7711a}'),

  QueryInterface: function (iid) {
    if (
      iid.equals(Components.interfaces.nsISimpleTest) ||
      iid.equals(Components.interfaces.nsISupports)
    )
      return this
    throw Components.results.NS_ERROR_NO_INTERFACE
  },

  add: function (a, b) {
    dump('add(' + a + ',' + b + ') from JS\n')
    return a + b
  },
}

this.NSGetFactory = XPCOMUtils.generateNSGetFactory([SimpleTest])

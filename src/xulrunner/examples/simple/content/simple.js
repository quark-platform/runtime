/* vim:set ts=2 sw=2 sts=2 et cin: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

console.log('Hello world!')

let lazy = {}
ChromeUtils.defineESModuleGetters(lazy, {
  BrowserToolboxLauncher:
    'resource://devtools/client/framework/browser-toolbox/Launcher.sys.mjs',
})

function launchDevTools() {
  lazy.BrowserToolboxLauncher.init()
}

function onButtonClick() {
  console.log('Button clicked')

  var textbox = document.getElementById('textbox')

  var contractid = '@test.mozilla.org/simple-test;1'

  var test = Cc[contractid].createInstance(Ci.nsISimpleTest)

  textbox.value = test.add(textbox.value, 1)
}

console.log(Cc)
console.log(document.getElementById('increment'))

document
  .getElementById('increment')
  .addEventListener('click', () => onButtonClick())
document
  .getElementById('open-devtools')
  .addEventListener('click', () => launchDevTools())

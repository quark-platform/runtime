// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// @ts-check

/**
 * @fileoverview implements the patching overview described in {@link ../docs/patching.md}
 */

import { exec } from 'node:child_process'
import { existsSync, statSync } from 'node:fs'
import { mkdir, readdir, symlink } from 'node:fs/promises'
import { join, resolve } from 'node:path'
import { exit } from 'node:process'
import { promisify } from 'node:util'

const execCmd = promisify(exec)

const CENTERAL = process.env.MOZILLA_CENTERAL
const SOURCE = process.env.SOURCE
const TARGET = process.cwd()
const PATCH_CMD = process.env.PATCH_CMD || 'patch'

if (!CENTERAL || !SOURCE) {
  console.error('You must specify a source and a centeral location')
  exit(1)
}

const evaluated = new Set()

async function patchFolder(/** @type {string} */ folder) {
  if (evaluated.has(folder)) return
  evaluated.add(folder)
  console.log(`evaluating ${folder}`)

  const centeralPath = resolve(CENTERAL, folder)
  const sourcePath = resolve(SOURCE, folder)
  const target = (/** @type {string} */ file) => resolve(TARGET, folder, file)

  const inCenteral = existsSync(centeralPath)
  const inSource = existsSync(sourcePath)

  const centeralContents = inCenteral && (await readdir(centeralPath))
  const sourceContents = inSource && (await readdir(sourcePath))

  if (centeralContents && sourceContents) {
    if (!existsSync(target('.'))) await mkdir(target('.'))

    const centeralLink = centeralContents
      .filter((file) => !sourceContents.includes(file))
      .filter((file) => !sourceContents.includes(`${file}.patch`))
      .filter((file) => statSync(resolve(centeralPath, file)).isFile())
      .map((file) => symlink(resolve(centeralPath, file), target(file)))
    const centeralChild = centeralContents
      .filter((file) => statSync(resolve(centeralPath, file)).isDirectory())
      .map((file) => join(folder, file))
      .map(patchFolder)

    const sourceLinks = sourceContents
      .filter((file) => !file.endsWith('.patch'))
      .filter((file) => statSync(resolve(sourcePath, file)).isFile())
      .map((file) => symlink(resolve(sourcePath, file), target(file)))
    const sourceChild = sourceContents
      .filter((file) => statSync(resolve(sourcePath, file)).isDirectory())
      .map((file) => join(folder, file))
      .map(patchFolder)

    const patches = sourceContents
      .filter((file) => file.endsWith('.patch'))
      .map(async (file) => {
        const name = file.slice(0, -'.patch'.length)
        const original = resolve(centeralPath, name)
        const patch = resolve(sourcePath, file)
        const out = target(name)

        await execCmd(
          `${PATCH_CMD} --input=${patch} --output=${out} ${original}`,
        )
      })

    await Promise.all([
      centeralLink,
      centeralChild,

      sourceLinks,
      sourceChild,

      patches,
    ])

    return
  }

  if (centeralContents) {
    await symlink(centeralPath, target('.'))
    return
  }

  if (sourceContents) {
    await symlink(sourcePath, target('.'))
    return
  }
}

await patchFolder('.')

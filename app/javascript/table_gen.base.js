// eslint-disable-next-line import/no-extraneous-dependencies
import 'core-js/stable'
// eslint-disable-next-line import/no-extraneous-dependencies
import 'regenerator-runtime/runtime'
import * as Mousetrap from 'mousetrap'
import { Turbo } from '@hotwired/turbo-rails'
import Rails from '@rails/ujs'
import tippy from 'tippy.js'

import './js/controllers'

Rails.start()

window.Turbolinks = Turbo

let scrollTop = null
Mousetrap.bind('r r r', () => {
  // Cpture scroll position
  scrollTop = document.scrollingElement.scrollTop

  Turbo.visit(window.location.href, { action: 'replace' })
})

function initTippy() {
  tippy('[data-tippy="tooltip"]', {
    theme: 'light',
    content(reference) {
      const title = reference.getAttribute('title')
      reference.removeAttribute('title')
      reference.removeAttribute('data-tippy')

      return title
    },
  })
}

window.initTippy = initTippy

document.addEventListener('turbo:load', () => {
  initTippy()

  // Restore scroll position after r r r turbo reload
  if (scrollTop) {
    setTimeout(() => {
      document.scrollingElement.scrollTo(0, scrollTop)
      scrollTop = 0
    }, 50)
  }

  setTimeout(() => {
    document.body.classList.remove('turbo-loading')
  }, 1)
})

document.addEventListener('turbo:frame-load', () => {
  initTippy()
})

document.addEventListener('turbo:visit', () => document.body.classList.add('turbo-loading'))
document.addEventListener('turbo:submit-start', () => document.body.classList.add('turbo-loading'))
document.addEventListener('turbo:submit-end', () => document.body.classList.remove('turbo-loading'))
document.addEventListener('turbo:before-cache', () => {
  document.querySelectorAll('[data-turbo-remove-before-cache]').forEach((element) => element.remove())
})

window.TableGen = window.TableGen || { configuration: {} }

window.TableGen.menus = {
  resetCollapsedState() {
    Array.from(document.querySelectorAll('[data-menu-key-param]'))
      .map((i) => i.getAttribute('data-menu-key-param'))
      .filter(Boolean)
      .forEach((key) => {
        window.localStorage.removeItem(key)
      })
  },
}

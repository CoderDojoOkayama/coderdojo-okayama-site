$(document).ready(() => {
  $(".responsive-iframe").cbIframeSize();
  let hash = $(window.location.hash).is('*') ? window.location.hash : '#overview'
  window.location.hash = hash
  setDefaultHeroTab(hash)
});

$('.navbar-burger').on('click', e => {
  $('#navBurger').hasClass('is-active') ? $('#navBurger').removeClass('is-active') : $('#navBurger').addClass('is-active')
})

$('.hero-foot>.tabs .tab').on('click', function() {
  $('.hero-foot>.tabs .tab').removeClass('is-active')
  $(this).addClass('is-active')
  $('main>section').addClass('is-hidden')
  const displayElement = $(this).attr('data-target')
  window.location.hash = displayElement
  $(`#${displayElement}`).removeClass('is-hidden')
})

function setDefaultHeroTab(hash) {
  id = hash.split('#').join('')

  $('.hero-foot>.tabs .tab').removeClass('is-active')
  $(`.hero-foot>.tabs .tab-${ id }`).addClass('is-active')

  $('main>section').addClass('is-hidden')
  $(hash).removeClass('is-hidden')
}
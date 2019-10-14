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
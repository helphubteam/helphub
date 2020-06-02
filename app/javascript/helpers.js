document.addEventListener("DOMContentLoaded", ()=> {
  handlePrintDatetime();
})

const handlePrintDatetime = () => {
  const items = Array.from(document.getElementsByClassName('js-print-datetime'))
  const options = { month: 'long', day: 'numeric', hour: 'numeric', minute: '2-digit' }

  items.forEach(element => {
    datetime = new Date(element.innerHTML)
    fixed_datetime = datetime.toLocaleString('ru', options)
    element.innerHTML = fixed_datetime
    element.removeAttribute('class')
  });
}

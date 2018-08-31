var inputs = document.getElementsByTagName('input');
var inputsAsArray = Array.prototype.slice.call( inputs )
var showInputs = inputsAsArray.filter(input => input.value === 'showeverywhere')
var hideInputs = inputsAsArray.filter(input => input.value === 'hideeverywhere')
showInputs.forEach(input => input.click())

// Hide - defaults
var inputs = document.getElementsByTagName('input');
var inputsAsArray = Array.prototype.slice.call( inputs )
var showInputs = inputsAsArray.filter(input => input.value === 'showeverywhere')
var hideInputs = inputsAsArray.filter(input => input.value === 'hideeverywhere')
hideInputs.forEach(input => input.click())
showInputs[3].click()
showInputs[6].click()
showInputs[7].click()
showInputs[8].click()
showInputs[10].click()
showInputs[11].click()

// Liquid Assets - Without 401k
var inputs = document.getElementsByTagName('input');
var inputsAsArray = Array.prototype.slice.call( inputs )
var showInputs = inputsAsArray.filter(input => input.value === 'showeverywhere')
var hideInputs = inputsAsArray.filter(input => input.value === 'hideeverywhere')
showInputs.forEach(input => input.click())
hideInputs[12].click()
hideInputs[13].click()
hideInputs[14].click()

// Purely Liquid Assets - Without all investments
var inputs = document.getElementsByTagName('input');
var inputsAsArray = Array.prototype.slice.call( inputs )
var showInputs = inputsAsArray.filter(input => input.value === 'showeverywhere')
var hideInputs = inputsAsArray.filter(input => input.value === 'hideeverywhere')
hideInputs.forEach(input => input.click())
showInputs[2].click()
showInputs[3].click()
showInputs[5].click()
showInputs[6].click()
showInputs[7].click()
showInputs[8].click()
showInputs[9].click()
showInputs[10].click()
showInputs[11].click()

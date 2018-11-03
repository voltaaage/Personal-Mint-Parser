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
showInputs[8].click()
showInputs[9].click()
showInputs[10].click()
showInputs[12].click()
showInputs[13].click()
showInputs[17].click()
showInputs[19].click()

// Liquid Assets - Without 401k
var inputs = document.getElementsByTagName('input');
var inputsAsArray = Array.prototype.slice.call( inputs )
var showInputs = inputsAsArray.filter(input => input.value === 'showeverywhere')
var hideInputs = inputsAsArray.filter(input => input.value === 'hideeverywhere')
showInputs.forEach(input => input.click())
hideInputs[1].click()
hideInputs[13].click()
hideInputs[14].click()
hideInputs[15].click()

// Purely Liquid Assets - Without all investments
var inputs = document.getElementsByTagName('input');
var inputsAsArray = Array.prototype.slice.call( inputs )
var showInputs = inputsAsArray.filter(input => input.value === 'showeverywhere')
var hideInputs = inputsAsArray.filter(input => input.value === 'hideeverywhere')
hideInputs.forEach(input => input.click())
showInputs[3].click()
showInputs[4].click()
showInputs[6].click()
showInputs[7].click()
showInputs[8].click()
showInputs[9].click()
showInputs[10].click()
showInputs[11].click()
showInputs[12].click()
showInputs[16].click()
showInputs[18].click()

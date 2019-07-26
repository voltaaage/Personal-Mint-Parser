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
showInputs[accounts['capitalOneChecking']].click()
showInputs[accounts['chaseAmazon']].click()
showInputs[accounts['chaseSapphireReserve']].click()
showInputs[accounts['chaseFreedom']].click()
showInputs[accounts['discover1']].click()
showInputs[accounts['discover2']].click()
showInputs[accounts['nordstrom']].click()
showInputs[accounts['chaseChecking']].click()

// Liquid Assets - Without IRAs
var inputs = document.getElementsByTagName('input');
var inputsAsArray = Array.prototype.slice.call( inputs )
var showInputs = inputsAsArray.filter(input => input.value === 'showeverywhere')
var hideInputs = inputsAsArray.filter(input => input.value === 'hideeverywhere')
showInputs.forEach(input => input.click())
hideInputs[accounts['fidelityEpic']].click()
hideInputs[accounts['fidelityExpedia']].click()
hideInputs[accounts['bettermentRoth']].click()
hideInputs[accounts['vanguardRoth']].click()

// Purely Liquid Assets - Without all investments
var inputs = document.getElementsByTagName('input');
var inputsAsArray = Array.prototype.slice.call( inputs )
var showInputs = inputsAsArray.filter(input => input.value === 'showeverywhere')
var hideInputs = inputsAsArray.filter(input => input.value === 'hideeverywhere')
hideInputs.forEach(input => input.click())
showInputs[accounts['capitalOneChecking']].click()
showInputs[accounts['chaseAmazon']].click()
showInputs[accounts['chaseSapphireReserve']].click()
showInputs[accounts['chaseFreedom']].click()
showInputs[accounts['discover1']].click()
showInputs[accounts['discover2']].click()
showInputs[accounts['nordstrom']].click()
showInputs[accounts['chaseChecking']].click()
showInputs[accounts['capitalOneMM']].click()
showInputs[accounts['capitalOneSavings']].click()

var accounts = {
    betterment:           0,
    bettermentRoth:       1,
    bettermentSavings:    2,
    bettermentSmart:      3,
    capitalOneChecking:   4,
    capitalOneMM:         5,
    capitalOneSavings:    6,
    chaseAmazon:          7,
    chaseSavings:         8,
    chaseSapphireReserve: 9,
    chaseFreedom:         10,
    chaseChecking:        11,
    discover1:            12,
    discover2:            13,
    fidelityEpic:         14,
    fidelityExpedia:      15,
    m1Finance:            16,
    nordstrom:            17,
    vanguardBrokerage:    18,
    vanguardRoth:         19,
    wealthfrontLine:      20,
    wealthfront:          21,
}

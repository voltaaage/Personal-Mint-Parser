require 'CSV'

# Setup parameters
file = './transactions.csv'
start_date = "11/01/2016"

# CONSTANTS
### Groceries ###
GROCERIES = [
  "Groceries"
]

### Dining    ###
DINING = [
  "Alcohol & Bars",
  "Coffee Shops",
  "Fast Food",
  "Food & Dining",
  "Restaurants"
]


### Travel    ###
TRAVEL = [
  "Air Travel",
  "Auto & Transport",
  "Auto Insurance",
  "Gas & Fuel",
  "Parking",
  "Public Transportation",
  "Rental Car & Taxi",
  "Travel"
]

### Purchases ###
PURCHASES = [
  "Amusement",
  "Bonus",
  "Books",
  "Business Services",
  "Check",
  "Clothing",
  "Dentist",
  "Doctor",
  "Electronics & Software",
  "Entertainment",
  "Federal Tax",
  "Financial",
  "Furnishings",
  "Gift",
  "Hair",
  "Health Insurance",
  "Home",
  "Home Improvement",
  "Home Services",
  "Hotel",
  "Internet",
  "Legal",
  "Mobile Phone",
  "Movies & DVDs",
  "Music",
  "Newspapers & Magazines",
  "Personal Care",
  "Pets",
  "Pharmacy",
  "Printing",
  "Service & Parts",
  "Shopping",
  "Sold Items",
  "Sporting Goods",
  "Sports"
]

### None      ###
NONE = [
  "ATM Fee",
  "Auto Payment",
  "Bank Fee",
  "Cash & ATM",
  "Charity",
  "Credit Card Payment",
  "Fees & Charges",
  "Finance Charge",
  "Financial Advisor",
  "Gym",
  "Income",
  "Interest Income",
  "Investments",
  "Late Fee",
  "Misc Expenses",
  "Mortgage & Rent",
  "Paycheck",
  "Reimbursement",
  "Service Fee",
  "Shipping",
  "State Tax",
  "Stocks",
  "Taxes",
  "Transfer",
  "Transfer for Cash Spending",
  "Tuition",
  "Uncategorized"
]


def main(file, start_date)

  puts "Date|Description|Amount|Original_Description|Notes"

  transactions = read_file(file)
  transactions.shift # removes the header from the mint export

  process(transactions, start_date)
end

def read_file(file)
  transactions = []
  CSV.foreach(file) do |row|
    # Core Info
    date = row[0]
    description = row[1]
    amount = row[3]
    category = row[5]
    transaction_type = row[4]

    # Additional Info
    original_description = row[2]
    notes = row[8]

    transactions << {
      date: date,
      description: description,
      amount: amount,
      category: category,
      original_description: original_description,
      notes: notes,
      transaction_type: transaction_type
    }
  end
  transactions
end

def process(transaction_group, start_date)
  transaction_group.each do |transaction|
    processing(transaction, start_date)
  end
end

def processing(transaction, start_date)
  internal_start_date = Date.strptime(start_date, '%m/%d/%Y')
  internal_transaction_date = Date.strptime(transaction[:date], '%m/%d/%Y')

  if internal_transaction_date > internal_start_date
    if transaction[:transaction_type] == "credit"
      transaction[:amount] = "-#{transaction[:amount]}"
    end

    puts "#{transaction[:date]}|#{transaction[:description]}|#{transaction[:amount]}|#{transaction[:original_description]}|#{transaction[:notes]}"
  end
end

main(file, start_date)

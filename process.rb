require 'CSV'

# Setup parameters
file = './transactions.csv'
START_DATE = "12/01/2016"
END_DATE = "12/31/2016"

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

RECURRING_PURCHASES = [
  "Gym",
  "Mobile Phone"
]

INCOME = [
  "Income",
  "Mortgage & Rent",
  "Interest Income",
  "Paycheck",
  "Reimbursement"
]

BANKING = [
  "Auto Payment",
  "Investments",
  "Transfer",
  "Credit Card Payment"
]

### None      ###
NONE = [
  "ATM Fee",
  "Bank Fee",
  "Cash & ATM",
  "Charity",
  "Fees & Charges",
  "Finance Charge",
  "Financial Advisor",
  "Late Fee",
  "Misc Expenses",
  "Service Fee",
  "Shipping",
  "State Tax",
  "Stocks",
  "Taxes",
  "Transfer for Cash Spending",
  "Tuition",
  "Uncategorized"
]


def main(file)

  CSV.open("./results.csv", "wb")
  transactions = read_file(file)
  transactions.shift # removes the header from the mint export

  groceries = parse_transactions(transactions, GROCERIES)

  dining = parse_transactions(transactions, DINING)
  travel = parse_transactions(transactions, TRAVEL)
  purchases = parse_transactions(transactions, PURCHASES)
  recurring_purchases = parse_transactions(transactions, RECURRING_PURCHASES)
  income = parse_transactions(transactions, INCOME)
  banking = parse_transactions(transactions, BANKING)
  none = parse_transactions(transactions, NONE)

  # CSV.open("./results.csv", "a") do |csv|

  #   # Add sums
  #   category_data("Groceries", groceries, csv)
  #   category_data("Dining", dining, csv)
  #   category_data("Travel", travel, csv)
  #   category_data("Purchases", purchases, csv)
  #   category_data("Recurring Purchases", recurring_purchases, csv)
  #   category_data("Income", income, csv)
  #   category_data("Banking", banking, csv)
  #   category_data("None", none, csv)
  # end

end

def parse_transactions(transactions, category)
  sorted_transactions = transactions.select{|transaction|
    category.include?(transaction[:category])
  }.sort_by{|t| t[:date]}

  CSV.open("./results.csv", "a") do |csv|

    # Add sums
    category_data("Title", sorted_transactions, csv)
  end
end

def category_data(title, transactions, csv)
    group_header(title, csv)
    sum = process(transactions, csv)
    sum
end

def group_header(name, csv)
  puts "\n#{name}"
  csv << [""]
  csv << [name]
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

def process(transaction_group, csv)
  puts "Date|Description|Amount|Category|Original_Description|Notes"
  csv << [ "Date", "Description", "Amount", "Category", "Original_Description", "Notes"]

  sum = 0
  transaction_group.each do |transaction|
    amount = processing(transaction, csv)
    sum = sum + amount.to_f
    sum = sum.round(2)
  end

  puts "Total: $#{sum}"
  csv << ["Total: $#{sum}"]
  sum
end

def processing(transaction, csv)
  internal_start_date = Date.strptime(START_DATE, '%m/%d/%Y')
  internal_end_date = Date.strptime(END_DATE, '%m/%d/%Y')

  internal_transaction_date = Date.strptime(transaction[:date], '%m/%d/%Y')

  if internal_transaction_date >= internal_start_date && internal_transaction_date <= internal_end_date
    amount = transaction[:amount].to_f

    if transaction[:transaction_type] == "credit"
      amount = amount * -1
    end

    csv_row = []
    csv_row << transaction[:date]
    csv_row << transaction[:description]
    csv_row << amount
    csv_row << transaction[:category]
    csv_row << transaction[:original_description]
    csv_row << transaction[:notes]
    puts csv_row.join("|")
    csv << csv_row

    amount
  end
end

main(file)

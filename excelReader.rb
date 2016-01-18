require 'csv'
require 'green_shoes'

COMPANY_ONE = 0
COMPANY_TWO = 1
MIN_NUMBER_OF_COMPANIES = 2

Company = Struct.new(:symbol, :price)

def processCSV(fileName, companyList)

	headers = CSV.open(fileName, 'r') { |csv| csv.first }
	symbolRow = headers.index("Symbol")
	subIndustryRow = headers.index("Same Sub-Industry As")
	priceRow = headers.index("Price")

	CSV.foreach(fileName) do |row|
		symbol = row[symbolRow]
		subIndustry = row[subIndustryRow]
		price = row[priceRow]
		company = Company.new
		company.symbol = symbol
		company.price = price.delete('$ ,').to_f
		companyList[subIndustry] += [company]
	end
end

def getSubIndustryPairs(subIndustry, companyList)
	pairList = companyList[subIndustry].sort_by(&:price)
	pairList = pairList.combination(2).to_a
end

def createTestPairs(companyList, pairList)
	companyList.keys.each do |subIndustry|
		if companyList[subIndustry].size < MIN_NUMBER_OF_COMPANIES
			companyList.delete(subIndustry)
		else
			pairList += getSubIndustryPairs(subIndustry,companyList)
		end
	end
	return pairList
end

def exportCSV(pairList)
	CSV.open("PairList.csv", "w") do |csv|
		pairList.each do |pair|
			csv << [pair[COMPANY_ONE].symbol,pair[COMPANY_TWO].symbol]
		end
	end
end

companyList = Hash.new(Array.new)
pairList = Array.new

fileName = ask_open_file

processCSV(fileName,companyList)
pairList = createTestPairs(companyList,pairList)
exportCSV(pairList)





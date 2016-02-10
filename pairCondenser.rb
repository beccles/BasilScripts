require 'csv'
require 'tk'

SYMBOL_ONE = 0
SYMBOL_TWO = 1


def processCSV(fileName, symbolList)

	rowNumber = 0;
	index = 0;
	CSV.foreach(fileName) do |row|
		if (rowNumber != 0 && row[0] != nil)
			symbolList[index] += [row[SYMBOL_ONE],row[SYMBOL_TWO]]
			index += 1
		end
		if rowNumber == 0
			rowNumber += 1
		end
	end
end

def condensePairs(symbolList, condensedList)

	condensedListCounter = 0
	condensedList[condensedListCounter] += symbolList[symbolList.keys.first]
	symbolList.delete(symbolList.keys.first)

	while !symbolList.empty?

		pairRemoved = false
		symbolList.each do |index,pair|
			#check if either symbol in pair is in a set of symbols in condensedList
			#if so add the symbol that's not in the set to the set and remove it from symbolList
			condensedList.each do |i, symbolSet|

				if symbolSet.include?(pair[SYMBOL_ONE])
					addToCondesnedList(condensedList, i, symbolList, index, pair[SYMBOL_TWO], pairRemoved)

				elsif symbolSet.include?(pair[SYMBOL_TWO])
					addToCondesnedList(condensedList, i, symbolList, index, pair[SYMBOL_ONE], pairRemoved)
				end
			end
		end
		#if no pairs were removed add the next pair in symbolList to condensedList
		if !pairRemoved 
			condensedListCounter += 1
			condensedList[condensedListCounter] += symbolList[symbolList.keys.first]
			symbolList.delete(symbolList.keys.first)
		end
	end
end

def addToCondesnedList(condensedList, condensedListIndex, symbolList, symbolListIndex, symbol, pairRemoved)
	condensedList[condensedListIndex] += [symbol]
	symbolList.delete(symbolListIndex)
	pairRemoved = true
end

def exportCSV(condensedList, exportedFileName)
	CSV.open(exportedFileName, "w") do |csv|
		condensedList.each do |index, pair|
			csv << pair.each {|symbol| symbol}
		end
	end
end

fileName = Tk.getOpenFile('defaultextension' => 'csv','filetypes' => "{{Comma Seperated Values} {.csv}} {{All Files} *}")

symbolList = Hash.new(Array.new)
processCSV(fileName,symbolList)

condensedList = Hash.new(Array.new)
condensePairs(symbolList,condensedList)

exportedFileName = Tk::getSaveFile('defaultextension' => 'csv','filetypes' => "{{Comma Seperated Values} {.csv}}")

exportCSV(condensedList, exportedFileName)



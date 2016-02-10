require 'csv'
require 'tk'

def processCSV(longListFileName, symbolListFileName, statusList, symbolList)
	headers = CSV.open(longListFileName, 'r') { |csv| csv.first }
	symbolRow = headers.index("*Symbol")
	statusRow = headers.index("Status Description")

	CSV.foreach(longListFileName) do |row|
		statusList[row[symbolRow].strip] = row[statusRow]
	end

	index = 0
	CSV.foreach(symbolListFileName) do |row|
		symbolList[index] = row[0].strip
		index += 1
	end
end

def findStatus(statusList, symbolList, symbolsWithStatus)
	symbolList.each do |symbol|
		if !statusList.has_key?(symbol)
			symbolsWithStatus[symbol] = "no match"
		else
			symbolsWithStatus[symbol] = statusList[symbol]
		end
	end
end

def exportCSV(symbolsWithStatus, exportedFileName)
	CSV.open(exportedFileName, "w") do |csv|
		symbolsWithStatus.each do |symbol, status|
			csv << [symbol,status]
		end
	end
end

msgBox1 = Tk.messageBox(
  'type'    => "ok",  
  'message' => "Select file from company"
)
longListFileName = Tk.getOpenFile('defaultextension' => 'csv','filetypes' => "{{Comma Seperated Values} {.csv}} {{All Files} *}")
msgBox2 = Tk.messageBox(
  'type'    => "ok",  
  'message' => "Select file with symbols you trade"
)
symbolListFileName = Tk.getOpenFile('defaultextension' => 'csv','filetypes' => "{{Comma Seperated Values} {.csv}} {{All Files} *}")

statusList = Hash.new
symbolList = Array.new
symbolsWithStatus = Hash.new

exportedFileName = Tk::getSaveFile('defaultextension' => 'csv','filetypes' => "{{Comma Seperated Values} {.csv}}")

processCSV(longListFileName, symbolListFileName, statusList, symbolList)
findStatus(statusList, symbolList, symbolsWithStatus)
exportCSV(symbolsWithStatus, exportedFileName)


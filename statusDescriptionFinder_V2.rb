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
		if row[0] != nil
			symbolList[index] = row[0].strip
			index += 1
		end
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

processCSV(longListFileName, symbolListFileName, statusList, symbolList)
findStatus(statusList, symbolList, symbolsWithStatus)

companyFile = longListFileName.split("/").last
strippedCompanyFile = companyFile.split("_")[0] #get date part of the file name

shorterSymbolListFileName = symbolListFileName.split("/").last
symbolListFileName.slice!(shorterSymbolListFileName)

exportedFileName = symbolListFileName + "LOCATES" + strippedCompanyFile + ".csv"
if File.file?(exportedFileName)
	result = Tk.messageBox(
		'type' => 'yesno', 
	    'message' => 'You are about to overwrite an existing file. Do you want to do this? If no you will be prompted for a new filename', 
	    'icon' => 'question')
	if result != "yes"
		exportedFileName = Tk::getSaveFile('defaultextension' => 'csv','filetypes' => "{{Comma Seperated Values} {.csv}}")
	end
end
exportCSV(symbolsWithStatus, exportedFileName)


local Item = SSC:NewModule("Item")

function Item:Execute(arg)
    if SSC:IsNumber(arg) then
        Item:SearchById(tonumber(arg))
    else
        Item:SearchByText(arg)
    end
end

-- /ssc item 2722460
function Item:SearchById(id)
    local link = select(2, GetItemInfo(id))

    if link then
        SSC:Print("Item found: "..link)
    else
        SSC:Print("Item "..id.." not cached yet or doesn't exist.")
    end
end

-- /ssc item Chromatic Headpiece
function Item:SearchByText(text)
    text = text:lower()
	for i=1, 400000 do 
		local n, _, _, _, _, _, _, _, _, _, _, _, _, _, _, id = GetItemInfo(i) 
        if n and n:lower():find(text) then 
			local link = select(2, GetItemInfo(i)) 
			if link then 
				SSC:Print("Item found: "..link) 
			end 
		end 
	end 
end

function Item:OnEnable()
    local helpText = { "item <item id>", "item <item search>" }

    SSC:RegisterCommand("item", 
        function(arg) Item:Execute(arg) end, 
        helpText)
end

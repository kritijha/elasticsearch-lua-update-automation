------------------------------------------------------------------
--Author : Kriti Jha
------------------------------------------------------------------

local json = require 'cjson'
local https = require 'ssl.https'

JRead = {}
url1 = 'https://api.github.com/repos/elastic/elasticsearch/contents/rest-api-spec/src/main/resources/rest-api-spec/api'
url2 = 'https://api.github.com/repos/DhavalKapil/elasticsearch-lua/contents/src/elasticsearch/endpoints'

function JRead:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

------------------------------------------------------------------
--fetch data about contents of repository
------------------------------------------------------------------

function JRead:get_doc(url)
	local tab = {}
	self.body = assert(https.request(url))
	k = JSONtoLuaTable(self.body)
	l = 1
	for i = 1,#k do
		if k[i].type == 'dir' then
			new_url = url .. "/" .. k[i].name
			s = assert(https.request(new_url))
			t = JSONtoLuaTable(s)
			for j = 1,#t do
				s1 = k[i].name .. "." .. t[j].name
				if  string.find(s1,".json") then
					a = string.find(s1,".json")
					s = string.lower(string.sub(s1,1,a-1))
					if string.find(s,"_") then
						a = string.find(s,"_")
						s = string.sub(s,1,a-1) .. string.sub(s,a+1)
					end
				elseif string.find(s1,".lua") then
					a = string.find(s1,".lua")
					s = string.lower(string.sub(s1,1,a-1))
				end
				tab[l] = s
				l = l+1
			end
		else
			if string.find(k[i].name,".json") then
				a = string.find(k[i].name,".json")
				s = string.lower(string.sub(k[i].name,1,a-1))
				if string.find(s,"_") then	
					a = string.find(s,"_")
					s = string.sub(s,1,a-1) .. string.sub(s,a+1)
				end
			elseif string.find(k[i].name,".lua") then
				a = string.find(k[i].name,".lua")
				s = string.lower(string.sub(k[i].name,1,a-1))
			end
			if s == "endpoint" then
			else
				tab[l] = s
				l = l+1
			end
		end
		
	end
	return tab
end

------------------------------------------------------------------
--convert JSON data into a lua table
------------------------------------------------------------------

function JSONtoLuaTable (json_string)
	local tab = json.decode(json_string)
	return tab
end

------------------------------------------------------------------
--find elements of one table that are missing from the other
------------------------------------------------------------------

function difference(t1, t2)
	local ret = {}
	local flag = 0
	local j=0
	for k,v in ipairs(t1) do 
		for k1,v1 in ipairs(t2) do 
			if v1 == v then
				 flag = 1
				 break
			else
				flag =0
			end
		end
		if flag == 0 then
			j = j+1
			ret[j] = v
		end
	end
	return ret
end

------------------------------------------------------------------
--print lua table
------------------------------------------------------------------

function printTab (t)
	for i = 1,#t do
		print (t[i])
	end
	print("Number of endpoints :" .. #t)
	print("\n")
end

------------------------------------------------------------------
--creation of an object of JRead class
------------------------------------------------------------------

obj = JRead:new ()

------------------------------------------------------------------
--printing components of both repositories
------------------------------------------------------------------

tab1 = obj:get_doc(url1)
print("Endpoints of elasticsearch repository \n")
printTab (tab1)

tab2 = obj:get_doc(url2)
print("Endpoints of elasticsearch-lua repository \n")
printTab (tab2)

------------------------------------------------------------------
--printing components of both repos missing from the other repo
------------------------------------------------------------------

RTab = difference(tab1,tab2)
print("Endpoints of elasticsearch repository that are missing from elasticsearch-lua repository\n")
printTab (RTab)

RTab1 = difference(tab2,tab1)
print("Endpoints of elasticsearch-lua repository that are not present in elasticsearch repository\n")
printTab (RTab1)

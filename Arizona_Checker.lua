local sampev = require("samp.events")
require("addon")
local inicfg = require("inicfg")

------------------------------------- �� ������ �� ��� �����

local watpasword = getBotNick()
local cfg = inicfg.load(nil, watpasword)

local checkemeila = false -- ����� �� ��� ������ (�� �������)
local checkprisona = false -- ����� �� ��� �������������� ����� (� ������, �� �������)

local emailConfirmed = false -- �������� �� �����
local vkConfirmed = false -- �������� �� ��

local stat -- ����� ����������
local rakstat = "" -- ������� �� ����������, ����� - ���
local playerinventory = "" -- ������ �� ���������, ����� - ���
local lic = "" -- ������� �� ��������, ����� - ���
local skills = "" -- ������� �� �����, ����� - ���
local playerscar = "" -- ������� �� ����������, ����� - ���
local playersbusines = "" -- ������� �� �������, ����� - ���
local playershouses = "" -- ������� �� ����, ����� - ���
local playerprison = "" -- ������� �� ������, ����� - ���
local playerjail = "0" -- ������ �� ��������, ����� - ���
local money = 1000 -- ������ �� ��������
local playerSkin = 0 -- ���� ����� �� ��������
local level = 1 -- ����� ��������

local carschecked = false -- ������� �� ����������
local housechecked = false -- ������� �� ����
local busineschecked = false -- ������� �� ������� �������
local prisonchecked = false -- ������� �� ������

local aray -- ���
local bezd = 0 -- ���
local bezod = 0 -- ���
local spawned = false -- ���
local beleboba = 0 -- ���
local mmmmm = false -- ���
local baned = 0 -- ���
local conectfailed = 0 -- ���

-------------------------------------

function removeColors(arg)
	if string.len(arg) > 1 then
		if arg:find("{[^}]+}") then
			text = string.gsub(arg, "{[^}]+}", "")
			return text
		else
			return arg
		end
	end
end


function forstat()
	mmmmm = true
	if emailConfirmed == true then
		emailConfirmed = 1
	end
	if emailConfirmed == false then
		emailConfirmed = 0
	end
	if vkConfirmed == true then
		vkConfirmed = 1
	end
	if vkConfirmed == false then
		vkConfirmed = 0
	end
	
	if string.len(stat) > 1 then
		statt = removeColors(stat)
		if statt:find("�������: %[(%d+)%]") then
			level = string.match(statt, "%[(%d+)%]")
		end
	end
	
	if string.len(playerinventory) > 1 then
		playerinventory = removeColors(playerinventory)
		playerinventory = ("&!&������&!&���������: &!&������&!&"..playerinventory.."&!&������&!&")
	end

	lic = removeColors(lic)
	
	if string.len(playerscar) > 1 then
		playerscar = removeColors(playerscar)
		playerscar = playerscar.."&!&������&!&"
	end
	
	if string.len(playersbusines) > 1 then
		playersbusines = removeColors(playersbusines)
		playersbusines = playersbusines.."&!&������&!&"
	end
	
	if string.len(playershouses) > 1 then
		playershouses = removeColors(playershouses)
		playershouses = playershouses.."&!&������&!&"
	end

	if string.len(playerprison) > 1 then
		playerprison = removeColors(playerprison)
		playerprison = playerprison.."&!&������&!&"
	end
	
	local password = tostring(cfg.settings.pass)
	password = string.gsub(password, " ", "")
	
	filenamee = ("accs\\"..getBotNick()..".txt")
	local file = io.open(filenamee, "w")
	file:write(vkConfirmed.."|"..emailConfirmed.."|"..playersbusines.."|"..playerjail.."|"..playerscar.."|"..playershouses.."|"..statt.."|"..playerinventory.."|"..lic.."|"..level.."|"..money.."|"..playerSkin.."|"..getServerAddress().."|"..getBotNick().."|"..password.."|"..skills.."|"..getBotNick()..getServerAddress())
	file:close()
	
	print("������� ������� ��������.")
	exit()
end

function pripisat(arg)
	filenamee = ("accs\\"..getBotNick()..".txt")
	local file = io.open(filenamee, "w")
	file:write(tostring(arg))
	file:close()
	exit()
end

function endcheck(arg)
	if arg == 1 then
		forstat()
		reconnect(999999)
	end
	if arg == 2 then
		print("�� �������� ���������� ����-������� ����������� (���������)")
		pripisat(2)
		reconnect(999999)
	end
	if arg == 3 then
		print("�������� ������ �� ��������.")
		pripisat(3)
		reconnect(999999)
	end
	if arg == 4 then
		print("������ ������� ������������.")
		pripisat(4)
		reconnect(999999)
	end
	if arg == 5 then
		print("�� �������� ��������� ����������� �� �����.")
		pripisat(5)
		reconnect(999999)
	end
	if arg == 6 then
		print("�� �������� �������� ���� ��������������.")
		pripisat(6)
		reconnect(999999)
	end
	if arg == 7 then
		print("�� �������� ���-�� �����.")
		pripisat(7)
		reconnect(999999)
	end
	if arg == 8 then
		print("������� �� ���������������.")
		pripisat(8)
		reconnect(999999)
	end
	if arg == 9 then
		print("���� ������������. (����� ���� ��������)")
		pripisat(9)
		reconnect(999999)
	end
	if arg == 10 then
	    print("�� ���������� ����� �� ������ (�������� ���� ���-�� ������")
		pripisat(10)
		reconnect(999999)
	end
	if arg == 11 then
		print("������ ���������� �������� ����������.")
		pripisat(11)
		reconnect(999999)
	end
	if arg == 12 then
		print("�������� ������ �� ������� (������ ���������).")
		pripisat(12)
		reconnect(999999)
	end
end

newTask(function()
	local mdaa = 9
	while true do wait(0)
		if spawned then
			wait(4000)
			sendInput("/invent")
			while mdaa ~= 0 and not mmmmm do wait(0)
				wait(3000)
				sendInput("/mn")
				mdaa = mdaa - 1
			end
		end
	end
end)

function onUnload()
	os.remove(getPath("config\\"..getBotNick()..".ini"))
end

function sampev.onShowDialog(id, style, title, btn1, btn2, text)
	if text:find("\n") then
		--text = text:gmatch(text, "\n")
		--array = text:gmatch(text, "\n")
		text = text:gsub("\n", "&!&������&!&")
	end
	
	--print("Dialog title: "..title)
	--print("Dialog: "..text)
	
	if title:find('��� �') then
		playershouses = "���: ���� (�������� ��� ��������)"
		housechecked = true
		sendDialogResponse(id, 1, 0, "")
		sendInput("/mn")
		return false
	end
	
	if title:find('��������!') then
		sendDialogResponse(id, 0, 0, "")
		return false
	end
	
	if title:find("���� ����") or title:find("����� ����") then
		if text:find('� ��� ��� ���������') then
			playershouses = "���(�)/��������:�����������(��)"	
		else
			playershouses = "���: ���� (�������� ��� ��������)"
		end
		housechecked = true
		sendInput("/mn")
		return false
	end
	
	if title:find('��������') then
		lic = text
		beleboba = beleboba + 1
		if beleboba == 1 then endcheck(1) end
		--sendDialogResponse(id, 1, 0, "")
		return false
	end
	
	if title:find('���� ������� ������������') then
		endcheck(4)
		sendDialogResponse(id, 1, 0, "")
		return false
	end
	
	if title:find('���������') then
		endcheck(2)
		sendDialogResponse(id, 1, 0, "")
		return false
	end	
	
	if title:find('�����������') then
		if text:find('�������� ������!') then
			endcheck(3)
			sendDialogResponse(id, 1, 0, "")
			return false
		end	
		local password = tostring(cfg.settings.pass)
		password = string.gsub(password, " ", "")
		sendDialogResponse(id, 1, 0, password)
		return false
	else	
	
		if title:find('����� �� Arizona Role Play') then
			sendDialogResponse(id, 0, 0, "")
			return false
		end
	
		if text:find('�� ���������������') then
			endcheck(8)
			return false
		end
		
		if title:find('������� ����') then
			if text:find('�������������� ������') and not checkprisona then
				sendDialogResponse(id, 1, 13, "")
				return false
			end	
			if not checkemeila then
				sendDialogResponse(id, 1, 4, "")
				return false
			end	
			sendDialogResponse(id, 1, 0, "")
			return false
		else if title:find('������ ���������') then
				if not text:find('Hit Informer ��� ����������') then
					sendDialogResponse(id, 1, 7, "")
					return false
				end	
				sendDialogResponse(id, 1, 8, "")
				return false
			else
	
				if title:find('������������ ��������') then
					if text:find('****') then
						emailConfirmed = false
					else
						emailConfirmed = true
					end
					if text:find('�� ��������') then
						vkConfirmed = false
					else
						vkConfirmed = true
					end
					checkemeila = true
					sendInput("/mn")
					return false
				end
	
				if title:find('�������� ��������') then
					if rakstat == "" and playerinventory == "" then
						sendDialogResponse(id, 1, 0, "")
						return false
					end
					if not carschecked then
						sendDialogResponse(id, 1, 1, "")
						return false
					end
					if not housechecked then
						sendDialogResponse(id, 1, 2, "")
						return false
					end
					if not busineschecked then
						sendDialogResponse(id, 1, 3, "")
						return false
					else
						sendDialogResponse(id, 1, 6, "")
						return false
					end
				else
					
					if title:match('�������� ����������') then
						stat = text
						sendDialogResponse(id, 1, 0, "")
						return false
					end
	
					if text:find('[����]') then
						if text:find("{FFFFFF}") then
							text:sub(text:find("{FFFFFF}"))
						end
						playerinventory = (playerinventory..text.."\n")
						if text:find(">> ��������� ��������") then
							sendDialogResponse(id, 1, 41, "")
							return false
						end
						sendDialogResponse(id, 1, 0, "")
						sendInput("/mn")
						return false
					else
		
						if title:find('Halloween') then
							sendDialogResponse(id, 0, 0, "")
							return false
						end

						if title:find('��� ���������') then
							playerscar = "���������:\n" .. text
							carschecked = true
							sendDialogResponse(id, 1, 0, "")
							sendInput("/mn")
							return false
						end

						if title:find('��� �������') then
							text:gsub(".", ":")
							playersbusines = "������� (���/��������):\n" .. text
							busineschecked = true
							sendDialogResponse(id, 1, 0, "")
							sendInput("/mn")
							return false
						end

						if text:find('�� ��� {FFD450}E-MAIL{FFFFFF} ���� ����������') then
							endcheck(5)
							return false
						end

						if text:find('� ����� �������� ���������� ����������') then
							endcheck(6)
							return false
						end

						if text:find('������������� ������ ���������') then
							prisonchecked = true
							playerprison = "������: �������� � ������!"
							sendDialogResponse(id, 0, 0, "")
							sendInput("/mn")
							return false
						end
					end
				end
			end
		end
	end
end

function onPrintLog(text)
	newTask(function()
		if text:find("��� ������� ����������!") then
			playerscar = "���������:�����������"
			carschecked = true
			sendInput("/mn")
			return false
		end

		if text:find("�� ���������� � ����") then
			playershouses = "���(�)/��������:�����������(��)"
			housechecked = true
			sendInput("/mn")
			return false
		end
		
		if text:find("�� � ������ ����") then
			playershouses = "���: ���� (�������� ��� ��������)"
			housechecked = true
			sendInput("/mn")
			return false
		end
		
		if text:find("��� �������") then
			playersbusines = "������(�):�����������(��)"
			busineschecked = true
			sendInput("/mn")
			return false
		end
		
		if text:find("������� ��� �������������") then
			endcheck(7)
			return false
		end
		
		if text:find("You are banned") then
			baned = baned + 1
			if baned == 10 then
				endcheck(9)
			end
		end
		
		if text:find("Connection attempt failed.") or text:find("Connection request attempt failed") then
			conectfailed = conectfailed + 1
			if conectfailed == 10 then
				endcheck(10)
			end
		end
		
		if text:find("Connection was closed by the server.") then
			endcheck(11)
		end
		
		if text:find("Invalid password.") then
			endcheck(12)
		end
	end)
end

function onReceiveRPC(id, bs)
	if id == 12 then
		spawned = true
	end
	if id == 18 then
		money = bs:readInt32()
	end
	if id == 34 then
		id = getBotId()
		num4 = bs:readUInt16()
		num5 = bs:readUInt32()
		num6 = bs:readUInt16()
		if num4 == tonumber(id) and num5 >= 0 and num5 <= 10 then
			--print("skillID: "..tostring(num5).." | Level: "..tonumber(num6))
			for i = 0, 10 do
				if num5 == 0 then
					text = 'Pistol'
				end
				if num5 == 1 then
					text = 'Silenced Pistol'
				end
				if num5 == 2 then
					text = 'Desert Eagle'
				end
				if num5 == 3 then
					text = 'ShotGun'
				end
				if num5 == 4 then
					text = 'SawnOff ShotGun'
				end
				if num5 == 5 then
					text = 'SPAS12 ShotGun'
				end
				if num5 == 6 then
					text = 'Micro UZI'
				end
				if num5 == 7 then
					text = 'MP5'
				end
				if num5 == 8 then
					text = 'AK47'
				end
				if num5 == 9 then
					text = 'M4A1'
				end
				if num5 == 10 then
					text = 'SniperRifle'
				end
			end
			skills = skills .. text .. ": " .. num6 .. "&!&������&!&"
		end
	end
end

function sampev.onShowTextDraw(id, data)
	if id == 2132 or data.text:find("ID:") then
		s = data.text
		playerSkin = string.match(s, "(%d+)")
	end
	if id == 433 then
		sendClickTextdraw(id)
	end
	
	if id == 2300 then
		sendClickTextdraw(id)
	end
end

function sampev.onSetInterior(id)
	if id > 1 then
		print("�������� ��� ���� �������� ���� ���. ������ �����.")
		sendInput("/time")
	end
end

function sampev.onDisplayGameText(style, type, text)
	--print("message: "..text)
	if text:find("Welcome") then
		print("�������� ������ �������.")
	end
	if text:find("~g~ concluded ~w~") then
		messg = text:sub(text:find("~g~ concluded ~w~") + 17)
		if text:find("~n~") then
			messg = text:sub(0, text:find("~n~"))
			print("���: "..messg)
			playerjail = "����� ���: " .. messg .. " ���"
		end
	end
	
	if text:find("J�il�d") then
		messg2 = text:sub(text:find("Jailed"))
		messg2 = messg2:gsub("J�il�d", "��������:")
		print("��������: "..messg2)
		playerjail = messg2
	end
	
	if text:find("J�il�d") then
		messg3 = text:sub(text:find("Jailed"))
		messg3 = messg3:gsub("J�il�d", "��������:")
		print("��������: "..messg3)
		playerjail = messg3
	end
end

function onRunCommand(cmd)
    if cmd == "!check" then
		print("statt: "..statt)
		print("playerinventory: "..playerinventory)
		print("lic: "..lic)
		print("skills:"..skills)
		print("playerscar: "..playerscar)
		print("playersbusines: "..playersbusines)
		print("playershouses: "..playershouses)
		print("playerprison: "..playerprison)
		print("playerjail: "..playerjail)
		print("money: "..money)
		print("playerSkin: "..playerSkin)
		print("level: "..level)
        return false
    end
end
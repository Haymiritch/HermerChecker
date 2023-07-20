local sampev = require("samp.events")
require("addon")
local inicfg = require("inicfg")

------------------------------------- не менять всё что внизу

local watpasword = getBotNick()
local cfg = inicfg.load(nil, watpasword)

local checkemeila = false -- начат ли чек емейла (не трогать)
local checkprisona = false -- начат ли чек исправительных работ (в тюряге, не трогать)

local emailConfirmed = false -- привязан ли емейл
local vkConfirmed = false -- привязан ли вк

local stat -- текст статистики
local rakstat = "" -- чекнута ли статистика, пусто - нет
local playerinventory = "" -- чекнут ли инвентарь, пусто - нет
local lic = "" -- чекнуты ли лицензии, пусто - нет
local skills = "" -- чекнуты ли скилы, пусто - нет
local playerscar = "" -- чекнуты ли автомобили, пусто - нет
local playersbusines = "" -- чекнуты ли бизнесы, пусто - нет
local playershouses = "" -- чекнуты ли дома, пусто - нет
local playerprison = "" -- чекнута ли тюрьма, пусто - нет
local playerjail = "0" -- чекнут ли деморгна, пусто - нет
local money = 1000 -- деньги на аккаунте
local playerSkin = 0 -- айди скина на аккаунте
local level = 1 -- левел аккаунта

local carschecked = false -- чекнуты ли автомобили
local housechecked = false -- чекнуты ли дома
local busineschecked = false -- чекнуты ли чекнуты бизнесы
local prisonchecked = false -- чекнута ли тюрьма

local aray -- над
local bezd = 0 -- над
local bezod = 0 -- над
local spawned = false -- над
local beleboba = 0 -- над
local mmmmm = false -- над
local baned = 0 -- над
local conectfailed = 0 -- над

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
		if statt:find("Уровень: %[(%d+)%]") then
			level = string.match(statt, "%[(%d+)%]")
		end
	end
	
	if string.len(playerinventory) > 1 then
		playerinventory = removeColors(playerinventory)
		playerinventory = ("&!&ОТСТУП&!&Инвентарь: &!&ОТСТУП&!&"..playerinventory.."&!&ОТСТУП&!&")
	end

	lic = removeColors(lic)
	
	if string.len(playerscar) > 1 then
		playerscar = removeColors(playerscar)
		playerscar = playerscar.."&!&ОТСТУП&!&"
	end
	
	if string.len(playersbusines) > 1 then
		playersbusines = removeColors(playersbusines)
		playersbusines = playersbusines.."&!&ОТСТУП&!&"
	end
	
	if string.len(playershouses) > 1 then
		playershouses = removeColors(playershouses)
		playershouses = playershouses.."&!&ОТСТУП&!&"
	end

	if string.len(playerprison) > 1 then
		playerprison = removeColors(playerprison)
		playerprison = playerprison.."&!&ОТСТУП&!&"
	end
	
	local password = tostring(cfg.settings.pass)
	password = string.gsub(password, " ", "")
	
	filenamee = ("accs\\"..getBotNick()..".txt")
	local file = io.open(filenamee, "w")
	file:write(vkConfirmed.."|"..emailConfirmed.."|"..playersbusines.."|"..playerjail.."|"..playerscar.."|"..playershouses.."|"..statt.."|"..playerinventory.."|"..lic.."|"..level.."|"..money.."|"..playerSkin.."|"..getServerAddress().."|"..getBotNick().."|"..password.."|"..skills.."|"..getBotNick()..getServerAddress())
	file:close()
	
	print("Аккаунт успешно проверен.")
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
		print("На аккаунте установлен двух-этапная авторизация (ВКонтакте)")
		pripisat(2)
		reconnect(999999)
	end
	if arg == 3 then
		print("Неверный пароль от аккаунта.")
		pripisat(3)
		reconnect(999999)
	end
	if arg == 4 then
		print("Данный аккаунт заблокирован.")
		pripisat(4)
		reconnect(999999)
	end
	if arg == 5 then
		print("На аккаунте привязана авторизация по почте.")
		pripisat(5)
		reconnect(999999)
	end
	if arg == 6 then
		print("На аккаунте привязан гугл аутентефикатор.")
		pripisat(6)
		reconnect(999999)
	end
	if arg == 7 then
		print("На аккаунте кто-то сидит.")
		pripisat(7)
		reconnect(999999)
	end
	if arg == 8 then
		print("Аккаунт не зарегистрирован.")
		pripisat(8)
		reconnect(999999)
	end
	if arg == 9 then
		print("Айпи заблокирован. (может быть ошибочно)")
		pripisat(9)
		reconnect(999999)
	end
	if arg == 10 then
	    print("Не получилось войти на сервер (интернет либо что-то другое")
		pripisat(10)
		reconnect(999999)
	end
	if arg == 11 then
		print("Сервер неожиданно завершил соеденение.")
		pripisat(11)
		reconnect(999999)
	end
	if arg == 12 then
		print("Неверный пароль от севрера (сервер запаролен).")
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
		text = text:gsub("\n", "&!&ОТСТУП&!&")
	end
	
	--print("Dialog title: "..title)
	--print("Dialog: "..text)
	
	if title:find('Дом №') then
		playershouses = "Дом: есть (прописан или владелец)"
		housechecked = true
		sendDialogResponse(id, 1, 0, "")
		sendInput("/mn")
		return false
	end
	
	if title:find('Внимание!') then
		sendDialogResponse(id, 0, 0, "")
		return false
	end
	
	if title:find("Меню дома") or title:find("Выбор дома") then
		if text:find('У вас нет доступных') then
			playershouses = "Дом(а)/прописка:отсутствует(ют)"	
		else
			playershouses = "Дом: есть (прописан или владелец)"
		end
		housechecked = true
		sendInput("/mn")
		return false
	end
	
	if title:find('Лицензии') then
		lic = text
		beleboba = beleboba + 1
		if beleboba == 1 then endcheck(1) end
		--sendDialogResponse(id, 1, 0, "")
		return false
	end
	
	if title:find('Этот аккаунт заблокирован') then
		endcheck(4)
		sendDialogResponse(id, 1, 0, "")
		return false
	end
	
	if title:find('ВКонтакте') then
		endcheck(2)
		sendDialogResponse(id, 1, 0, "")
		return false
	end	
	
	if title:find('Авторизация') then
		if text:find('Неверный пароль!') then
			endcheck(3)
			sendDialogResponse(id, 1, 0, "")
			return false
		end	
		local password = tostring(cfg.settings.pass)
		password = string.gsub(password, " ", "")
		sendDialogResponse(id, 1, 0, password)
		return false
	else	
	
		if title:find('Акции на Arizona Role Play') then
			sendDialogResponse(id, 0, 0, "")
			return false
		end
	
		if text:find('не зарегистрирован') then
			endcheck(8)
			return false
		end
		
		if title:find('Игровое меню') then
			if text:find('Исправительные работы') and not checkprisona then
				sendDialogResponse(id, 1, 13, "")
				return false
			end	
			if not checkemeila then
				sendDialogResponse(id, 1, 4, "")
				return false
			end	
			sendDialogResponse(id, 1, 0, "")
			return false
		else if title:find('Личные настройки') then
				if not text:find('Hit Informer при попаданиях') then
					sendDialogResponse(id, 1, 7, "")
					return false
				end	
				sendDialogResponse(id, 1, 8, "")
				return false
			else
	
				if title:find('Безопасность аккаунта') then
					if text:find('****') then
						emailConfirmed = false
					else
						emailConfirmed = true
					end
					if text:find('не привязан') then
						vkConfirmed = false
					else
						vkConfirmed = true
					end
					checkemeila = true
					sendInput("/mn")
					return false
				end
	
				if title:find('Выберите действие') then
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
					
					if title:match('Основная статистика') then
						stat = text
						sendDialogResponse(id, 1, 0, "")
						return false
					end
	
					if text:find('[слот]') then
						if text:find("{FFFFFF}") then
							text:sub(text:find("{FFFFFF}"))
						end
						playerinventory = (playerinventory..text.."\n")
						if text:find(">> Следующая страница") then
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

						if title:find('Мой транспорт') then
							playerscar = "Транспорт:\n" .. text
							carschecked = true
							sendDialogResponse(id, 1, 0, "")
							sendInput("/mn")
							return false
						end

						if title:find('Мои бизнесы') then
							text:gsub(".", ":")
							playersbusines = "бизнесы (зам/владелец):\n" .. text
							busineschecked = true
							sendDialogResponse(id, 1, 0, "")
							sendInput("/mn")
							return false
						end

						if text:find('На ваш {FFD450}E-MAIL{FFFFFF} было отправлено') then
							endcheck(5)
							return false
						end

						if text:find('К этому аккаунту подключено приложение') then
							endcheck(6)
							return false
						end

						if text:find('Следовательно вашему наказанию') then
							prisonchecked = true
							playerprison = "Тюрьма: Персонаж в тюрьме!"
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
		if text:find("нет личного транспорта!") then
			playerscar = "Транспорт:отсутствует"
			carschecked = true
			sendInput("/mn")
			return false
		end

		if text:find("не проживаете в доме") then
			playershouses = "Дом(а)/прописка:отсутствует(ют)"
			housechecked = true
			sendInput("/mn")
			return false
		end
		
		if text:find("не у своего дома") then
			playershouses = "Дом: есть (прописан или владелец)"
			housechecked = true
			sendInput("/mn")
			return false
		end
		
		if text:find("нет бизнеса") then
			playersbusines = "Бизнес(ы):отсутствует(ют)"
			busineschecked = true
			sendInput("/mn")
			return false
		end
		
		if text:find("аккаунт уже авторизирован") then
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
			skills = skills .. text .. ": " .. num6 .. "&!&ОТСТУП&!&"
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
		print("Возможно КПЗ либо Деморган либо ТСР. Чекаем время.")
		sendInput("/time")
	end
end

function sampev.onDisplayGameText(style, type, text)
	--print("message: "..text)
	if text:find("Welcome") then
		print("Начинаем чекать аккаунт.")
	end
	if text:find("~g~ concluded ~w~") then
		messg = text:sub(text:find("~g~ concluded ~w~") + 17)
		if text:find("~n~") then
			messg = text:sub(0, text:find("~n~"))
			print("КПЗ: "..messg)
			playerjail = "ВРЕМЯ КПЗ: " .. messg .. " сек"
		end
	end
	
	if text:find("Jаilеd") then
		messg2 = text:sub(text:find("Jailed"))
		messg2 = messg2:gsub("Jаilеd", "Деморган:")
		print("Деморган: "..messg2)
		playerjail = messg2
	end
	
	if text:find("Jаilеd") then
		messg3 = text:sub(text:find("Jailed"))
		messg3 = messg3:gsub("Jаilеd", "Деморган:")
		print("Деморган: "..messg3)
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
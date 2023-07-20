import socket, os, requests, base64, hashlib, time, configparser
from subprocess import Popen

os.system('cls||clear')

logo = "\n██╗  ██╗███████╗██████╗ ███╗   ███╗███████╗██████╗\n██║  ██║██╔════╝██╔══██╗████╗ ████║██╔════╝██╔══██╗\n███████║█████╗  ██████╔╝██╔████╔██║█████╗  ██████╔╝\n██╔══██║██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══╝  ██╔══██╗\n██║  ██║███████╗██║  ██║██║ ╚═╝ ██║███████╗██║  ██║\n╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝\n"

def tomd5(arg):
    text = arg
    text = text.replace("&!&ОТСТУП&!&", "\n")
    m = hashlib.md5(text.encode())
    mm = m.hexdigest()
    mmm = mm.replace("-", "")
    return mmm

def tobase64(arg):
    text = arg
    text = text.replace("&!&ОТСТУП&!&", "\n")
    b = base64.b64encode(text.encode("utf-8")).decode("utf-8")
    return b

def saveini():
    with open('hermer.ini', 'w', encoding='utf-8') as config_file:
        config.write(config_file)

def settings_script():
    global poslednilog
    os.system('cls||clear')
    print(logo)
    print(f"Последний лог: {poslednilog}")
    print("[1] Путь к RakSamp Lite | [2] Токен Samp-Store | [3] Вернутся назад\n")
    
    vibor_1 = int(input("Выберите действие: "))
    if vibor_1 == 1:
        print(f"Путь на данный момент: {config.get('settings', 'raksamp_directory')}")
        directory = input("Введите путь к корневой папке RakSamp Lite: ")
        config.set('settings', 'raksamp_directory', directory)
        poslednilog = "Путь сохранён. Если он не верный ВСЁ СЛОМАЕТСЯ!!!"
        settings_script()
    if vibor_1 == 2:
        print(f"API Ключ на данный момент: {config.get('settings', 'ss_key')}")
        key = input("Введите API ключ от Samp-Store: ")
        if len(key) != 32:
            poslednilog = ("Перепроверьте свой API-ключ, он не верный.")
            settings_script()
        else:
            r = requests.get(f'https://samp-store.su/ajax/api.php?method=test&version=123&key={key}')
            if r.status_code == 200:
                text = r.text
                if text.find("OK") != -1:
                    config.set('settings', 'ss_key', key)
                    saveini()
                    poslednilog = "Токен Samp-Store верный и был сохранён."
                    settings_script()
                else:
                    poslednilog = "Перепроверьте свой API-ключ, он не верный."
                    settings_script()
            else:
                poslednilog = "Проверьте своё интернет-подключение."
                settings_script()
    if vibor_1 == 3:
        os.system('cls||clear')
        privetstviye()

def zagruzka_akkov_s_ss():
    global poslednilog
    os.system('cls||clear')
    print(logo)
    
    print(f"Последний лог: {poslednilog}")
    print("Загружаю аккаунты с Samp-Store для проверки...")
    
    key = config.get('settings', 'ss_key')
    r = requests.get(f'https://samp-store.su/ajax/api.php?method=get_accounts&key={key}')
    if r.status_code == 200:
        text = r.text
        nu = text.find("ERROR")
        if text == "":
            poslednilog = "Не найдено аккаунтов загруженных на Samp-Store."
            os.system('cls||clear')
            privetstviye()
        elif nu != -1:
            poslednilog = "Не верный API ключ либо что-то другое."
            os.system('cls||clear')
            privetstviye()
        else:
            text = text.replace("%", "|")
            with open("for_proverka.txt", "w", encoding="utf-8") as file:
                file.write(text)
            poslednilog = "Аккаунты успешно сохранены в for_proverka.txt для проверки."
            os.system('cls||clear')
            privetstviye()
    else:
        poslednilog = "Проверьте своё интернет-подключение."
        os.system('cls||clear')
        privetstviye()

def delete_acc_from_ss(id, log, statusreason, key, password):
    global poslednilog
    
    id = tobase64(id) #айди акка
    log = tobase64(log) # логин от акка
    status = tobase64(statusreason) # статус (тоже самое что и причина)
    reason = tobase64(statusreason) # причина (тоже самое что и статус)
    sta = tobase64('0') # не знаю что это но оно отправляется вместе с реквестом
    key = key # ключ
    password = tobase64(password) #пароль от акка
    
    r = requests.post('https://samp-store.su/ajax/test.php', data={
        "id": id,
        "log": log,
        "status": status,
        "reason": reason,
        "sta": sta,
        "key": key,
        "password": password,
    })
    if r.status_code == 200:
        if r.text != "ok":
            #все ок!
            poslednilog = poslednilog
        else:
            poslednilog = f"Что-то пошло не так во время удаления аккаунта!!! Ошибка: {r.text}"
            os.system('cls||clear')
            privetstviye()
    else:
        poslednilog = "Проверьте своё интернет подключение!"
        os.system('cls||clear')
        privetstviye()

def check_ss_akkov():
    global poslednilog
    print("\n[1] Проверить все аккаунты")
    vibor_3 = int(input("Выберите действие: "))
    if vibor_3 == 1:
        print("Начал проверять аккаунты.")
        
        with open('for_proverka.txt', 'r') as file:
            x = file.read()
            
        while True:            
            with open('for_proverka.txt', 'r') as file:
                lines = file.readlines()
                
            if len(lines) == 0:
                break
                
            linee = lines[-1].strip()
            
            if linee.find("п»ї") != -1:
                linee.replace("п»ї", "")
            
            with open('for_proverka.txt', 'w') as file:
                file.writelines(lines[:-1])
                
                array = linee.split("|")
                ip = array[0].split(":")
               
                
            print(f"Проверяю аккаунт: Ник: {array[1]} | Сервер: {array[0]} | Пароль: {array[2]} | Айди: {array[4]}")
            
            dirrr = config.get('settings', 'raksamp_directory')
            directoryr = (f'{dirrr}\\config\\{array[1]}.ini')
            with open(directoryr, "w", encoding="utf-8") as file:
                text = (f"[settings]\npass={array[2]}")
                file.write(text)
            
            Popen(f"{config.get('settings', 'raksamp_directory')}\\RakSAMP Lite.exe -h {ip[0]} -p {ip[1]} -n {array[1]}")
            
            filepath = (f"accs\\{array[1]}.txt")
            while not os.path.exists(filepath):
                time.sleep(1)
                
            with open(filepath, 'r') as file:
               x = file.read()
            
            #НЕ УМЕНИЕ ПОЛЬЗОВАТСЯ for DETECTED           
            if x == '1':
                text = ("успешно") #добавил для прикола
            elif x == '2':
                text = ("На аккаунте установлен двух-этапная авторизация (ВКонтакте)")
                delete_acc_from_ss(array[4], array[1], "Привязан ВКонтакте", config.get('settings', 'ss_key'), array[2])
            elif x == '3':
                text = ("Неверный пароль от аккаунта.")
                delete_acc_from_ss(array[4], array[1], "Пароль неверный", config.get('settings', 'ss_key'), array[2])
            elif x == '4':
                text = ("Данный аккаунт заблокирован.")
                delete_acc_from_ss(array[4], array[1], "Аккаунт заблокирован", config.get('settings', 'ss_key'), array[2])
            elif x == '5':
               text = ("На аккаунте привязана авторизация по почте.")
               delete_acc_from_ss(array[4], array[1], "Привязана авторизация по почте", config.get('settings', 'ss_key'), array[2])
            elif x == '6':
               text = ("На аккаунте привязан гугл аутентефикатор.")
               delete_acc_from_ss(array[4], array[1], "Привязан Google Authenticator", config.get('settings', 'ss_key'), array[2])
            elif x == '7':
                text = ("На аккаунте кто-то сидит.")
            elif x == '8':
                text = ("Аккаунт не зарегистрирован.")
                delete_acc_from_ss(array[4], array[1], "Аккаунт не зарегистрирован", config.get('settings', 'ss_key'), array[2])
            elif x == '9':
                text = ("Айпи заблокирован. (может быть ошибочно)")
            elif x == '10':
                text = ("Не получилось войти на сервер (интернет либо что-то другое)")
            elif x == '11':
                text = ("Сервер неожиданно завершил соеденение.")
            elif x == '12':
                text = ("Не удалось подключится к серверу")
            else:
                text = ("Аккаунт успешно проверен. Сохранён в менеджер аккаунтов.")
            
            if len(x) > 3:
                with open('accs\\manager_accounts.txt', 'a') as file:
                    x = x.replace("\n", "%%0A")
                    file.write(f'{x}|{array[4]}\n')
                    
            with open('accs\\log.txt', 'a') as file:
                file.write(f'Аккаунт: {array[1]} | Сервер: {array[0]} | Вердикт: {text}\n')
            print("Аккаунт проверен. Лог проверки аккаунта сохранён в log.txt в папке accs.")
            os.remove(filepath)
            
        poslednilog = ("Все аккаунты успешно проверены и занесены в менеджер аккаунтов.")

def check_akki_from_file():
    global poslednilog
    os.system('cls||clear')
    print(logo)
    print(f"Последний лог: {poslednilog}\n")
    
    print("Файл должен хранится в папке accs ! И иметь формат .txt")
    print("Акки должны иметь такой формат: ник|пароль|сервер ! 1 линия = 1 акк\n")
    filepatth = input("Введите НАЗВАНИЕ файла: ")
    filepatth = (f'accs\\{filepatth}.txt')
    
    with open(filepatth, 'r') as file:
        x = file.read()
            
    while True:
        with open(filepatth, 'r') as file:
            lines = file.readlines()
            
        if len(lines) == 0:
            break
            
        linee = lines[-1].strip()
        
        if linee.find("п»ї") != -1:
            linee.replace("п»ї", "")
        
        with open(filepatth, 'w') as file:
            file.writelines(lines[:-1])
           
            array = linee.split("|")
            ip = array[2].split(":")
               
                
        print(f"Проверяю аккаунт: Ник: {array[0]} | Сервер: {array[2]} | Пароль: {array[1]}")
            
        dirrr = config.get('settings', 'raksamp_directory')
        directoryr = (f'{dirrr}\\config\\{array[0]}.ini')
        with open(directoryr, "w", encoding="utf-8") as file:
            text = (f"[settings]\npass={array[1]}")
            file.write(text)
            
        Popen(f"{config.get('settings', 'raksamp_directory')}\\RakSAMP Lite.exe -h {ip[0]} -p {ip[1]} -n {array[0]}")
            
        filepath = (f"accs\\{array[0]}.txt")
        while not os.path.exists(filepath):
            time.sleep(1)
                
        with open(filepath, 'r') as file:
            x = file.read()
            
        #НЕ УМЕНИЕ ПОЛЬЗОВАТСЯ for DETECTED           
        if x == '1':
            text = ("успешно") #добавил для прикола
        elif x == '2':
            text = ("На аккаунте установлен двух-этапная авторизация (ВКонтакте)")
        elif x == '3':
            text = ("Неверный пароль от аккаунта.")
        elif x == '4':
            text = ("Данный аккаунт заблокирован.")
        elif x == '5':
            text = ("На аккаунте привязана авторизация по почте.")
        elif x == '6':
            text = ("На аккаунте привязан гугл аутентефикатор.")
        elif x == '7':
            text = ("На аккаунте кто-то сидит.")
        elif x == '8':
            text = ("Аккаунт не зарегистрирован.")
        elif x == '9':
            text = ("Айпи заблокирован. (может быть ошибочно)")
        elif x == '10':
            text = ("Не получилось войти на сервер (интернет либо что-то другое)")
        elif x == '11':
            text = ("Сервер неожиданно завершил соеденение.")
        elif x == '12':
            text = ("Не удалось подключится к серверу")
        else:
            text = ("Аккаунт успешно проверен. Сохранён в менеджер аккаунтов.")
            
        if len(x) > 3:
            with open('accs\\manager_accounts_custom.txt', 'a') as file:
                x = x.replace("\n", "%%0A")
                file.write(f'{x}\n')
                    
        with open('accs\\log.txt', 'a') as file:
            file.write(f'Аккаунт: {array[0]} | Сервер: {array[2]} | Вердикт: {text}\n')
        print("Аккаунт проверен. Лог проверки аккаунта сохранён в log.txt в папке accs.")
        os.remove(filepath)
            
    poslednilog = ("Все аккаунты успешно проверены и занесены в менеджер кастомных аккаунтов.")

def checker_accov():
    global poslednilog
    os.system('cls||clear')
    print(logo)
    print(f"Последний лог: {poslednilog}\n")
    
    print("Какие аккаунты нужно проверить?")
    print("[1] Загруженные на чек на Samp-Store | [2] Из текстовика | [3] Вывести логи проверки")
    print("[4] Вернутся назад")
    
    vibor_2 = int(input("Выборите действие: "))
    if vibor_2 == 1:
        path = (f"{config.get('settings', 'raksamp_directory')}\\chekcer\\mychecker\\for_proverka.txt")
        if os.path.exists(path):
            check_ss_akkov()
        else:
            poslednilog = "Не найдены аккаунты для чека. Загрузите аккаунты с Samp-Store."
            os.system('cls||clear')
            privetstviye()            
    if vibor_2 == 2:
        check_akki_from_file()       
    if vibor_2 == 3:
        print("\n")
        with open('accs\\log.txt', 'r') as file:
            lines = file.readlines()
            for line in lines:
                print(line.strip())
        print("\n[1] Очистить лог | [2] Вернутся назад\n")
        viborka = int(input("Выберите действие: "))
        if viborka == 1:
            with open('accs\\log.txt', 'r+') as file:
                file.truncate(0)
            poslednilog = ("Лог аккаунтов был успешно очищен.")
            os.system('cls||clear')
            privetstviye()
        if viborka == 2:    
            os.system('cls||clear')
            privetstviye()
    if vibor_2 == 4:
        os.system('cls||clear')
        privetstviye()

def zalit_akk_na_ss(proverka, mobile, emeil, login, business, tsr, cars, houses, statistika, inventory, licuhi, level, money, idskin, serverip, nickname, password, skill, idakka, price, regip, title, info):
    global poslednilog
    
    # Я ЭТИ ЗАПРОСЫ ДОСТАЛ ИЗ САМП СТОР ЧЕКЕРА, Я НЕЗНАЮ ПОЧЕМУ ВСЕ ТАКОЕ НЕ ПОНЯТНОЕ, Ulong'у СПАСИБО !!!
    # ЕСЛИ КАКОГО-ТО ПАРАМЕТРА НЕТУ, ТО ПРОСТО ОСТАВЬ ПУСТОЕ ПОЛЕ БЕЗ \n ДА И ВООБЩЕ \n НЕ СТАВЬ А ТО ВСЕ БАБАХНЕТ !!!
    # ДА ПРО ПОДМЕНУ ЗАПРОСОВ ТОЖЕ ЗНАЮ, НЕ НАДО СОЗДАВАТЬ ОБ ЭТОМ ТЕМУ НА БЛАСТ ХАКЕ И ГОВОРИТЬ ЧТО ВЫ АВТОР ПРИВАТ СПОСОБА ПОДМЕНЫ
    # ПРИКОЛЫ С СТАТИСКОЙ АККА, ИНВЕНТАРЕМ, СКИЛАМИ И ТД ВОЗМОЖНЫ, НЕ БАЛУЙТЕСЬ :)
    
    if proverka == 1:
        key = config.get('settings', 'ss_key') # ключ самп стора
        server = serverip # сервер (айпишник)
        price = price # цена за акк
        reg = regip # рег айпи 0.0.0.0
        alogin = nickname # логин аккаунта
        password = password # пароль от аккаунта
        code = '' # код какойто хз что это это скорее всего не на аризону
        info = info # инфа после покупки
        title = title # инфа акка
        
        r = requests.get(f'https://samp-store.su/ajax/api.php?method=add_account&version=15&key={key}&server={server}&price={price}&reg={reg}&alogin={alogin}&password={password}&code=&info={info}&tittle={title}')        
        if r.status_code == 200:
            array1 = r.text.split("|")
            if array1[0] == "OK":
                poslednilog = (f"Неизвестная ФАТАЛЬНАЯ ошибка при залитии аккаунта!!! Ошибка {r.text}")
                manager_ss_akkov()                 
            else:
                idakka = array1[1]
                zalit_akk_na_ss(2, mobile, emeil, login, business, tsr, cars, houses, statistika, inventory, licuhi, level, money, idskin, serverip, nickname, password, skill, idakka, price, "nil", "nil", "nil")
        else:
            poslednilog = ("Проблемы с интернетом. Фатальная ошибка!!!")
            manager_ss_akkov()
    if proverka == 2: 
        if len(tsr) < 2:
            tsr = ""
    
        text2 = tobase64(mobile) # привяза мобила ли
        text3 = tobase64(emeil) # привязан емейл ли
        text4 = tobase64(login) # логин от акка
        stat = (
            "" + # банк (не для аризоны скорее всего)
            business + #бизнесы
            tsr + # тср
            cars + # тачки
            houses + # дома
            statistika + # статистика
            inventory # инвентарь
        )
        text5 = tobase64(stat) # статистика
            
        text6 = tobase64(licuhi) # лицухи
          
        text7 = ""
        array2 = [0] * 10
        for i in range(10):
            text7 += str(array2[i]) + "|"
                
        text8 = tobase64(text7) # не знаю что это за белеберда но она обязательна в запросе
        text9 = tobase64(level) # уровень персонажа 
        text10 = tobase64(money) # деньги персонажа 
        text11 = tobase64(idskin) #айди скина персонажа
        text12 = tobase64(serverip) # айпишник севрера
        text13 = tobase64(nickname) # логин
        text14 = tobase64(password) # пароль от аккаунта
        text15 = tobase64('') # код хз это не для аризоны
        text16 = tobase64(skill) # скилы
        text17 = tobase64(idakka)
            
        inventory = tobase64(inventory) # инвентарь
            
        text18 = tomd5(f"x12es{text2}aw{text3}tt{text17}a{text15}=={text14}{text13}{text12}{text11}{text10}{text9}wdddcb8d749ceaac2f4f011baa8aecdea0bf{text5}60LjQtSDQv9GA0LDQstCwOiAg0{text16}yA/Pz8/Pz8/PyA/Pz8/Pz8/ID8KClNEUGlzdG9sOglbJycnJycnJycnJycnJ{text6}z8/Pz8/Pz8/Pz8/Pz8/OgkJMQo/Pz8/Pz8/Pz8/Pz86CQkwCj8")
            
        r = requests.post('https://samp-store.su/ajax/test.php', data={
            "level": text9,
            "money": text10,
            "skin": text11,
            "id": text17,
            "email": text3,
            "mob": text2,
            "log": text4,
            "inv": inventory,
            "skills": text16,
            "stat": text5,
            "lic": text6,
            "server": text18,
            "key": config.get('settings', 'ss_key')
        })
        if r.status_code == 200:
            if r.text != "ok":
                poslednilog = (f"Неизвестная ФАТАЛЬНАЯ ошибка при залитии аккаунта!!! Ошибка {r.text}")
                manager_ss_akkov()
            else:
                poslednilog = ("Аккаунт успешно залит на Samp-Store")
                manager_ss_akkov()
                
        else:
            poslednilog = ("Проблемы с интернетом. Фатальная ошибка!!!")
            manager_ss_akkov()

def manager_ss_akkov():
    global poslednilog
    os.system('cls||clear')
    print(logo)
    print(f"Последний лог: {poslednilog}\n")
    
    print("[1] Показать все аккаунты | [2] Вернутся назад\n")
    vibor_4 = int(input("Выберите действие: "))
    
    if vibor_4 == 1:
        with open('accs\\manager_accounts.txt', 'r') as file:
            lines = file.readlines()
            for line in lines:
                array = line.split("|")
                print(f'Айди: {array[17]} | Ник: {array[13]} | Пароль: {array[14]} | Сервер: {array[12]}')
        print('\n[1] Выставить аккаунт на продажу | [2] Вернутся назад')
        
        vibor_5 = int(input("Выберите действие: "))
        
        if vibor_5 == 1:
            id_akka = input("Введите айди аккаунта: ")
            with open('accs\\manager_accounts.txt', 'r') as file:
                found = False
                for line_number, line in enumerate(file, 1):
                    if id_akka in line:
                        found = True
                        
                        line = line.replace(" %%0A ", "")
                        line = line.replace(" %0A ", "")
                        line = line.replace("%%0A", "")
                        line = line.replace("%0A", "")
                        
                        line = line.strip()
                        array = line.split("|")
                        
                        print(f"\nАккаунт найден! \nДенег на аккаунте: {array[10]} \nУровень аккаунта: {array[9]} \nАйди скина: {array[11]} \nПривязан ли емейл: {array[1]} \nПривязан ли ВК: {array[0]} \nБизнесы: {array[2]} \nДома: {array[5]} \nМашины: {array[4]} \nТСР: {array[3]} \nОстальную информацию можно увидеть на {line_number} строке в файле manager_accounts.txt\n")
                        print("Пытаюсь залить аккаунт на Samp-Store...")
                        
                        serverr = (f'{array[12]}:7777')
                        zalit_akk_na_ss(2, array[0], array[1], array[13], array[2], array[3], array[4], array[5], array[6], array[7], array[8], array[9], array[10], array[11], serverr, array[13], array[14], array[15], id_akka, "nil", "nil", "nil", "nil")
                        
                        break

                if not found:
                    poslednilog = "Айди такого аккаунта не найден в менеджере аккаунтов SS"
                    os.system('cls||clear')
                    privetstviye()

        if vibor_5 == 2:
            os.system('cls||clear')
            privetstviye()
    if vibor_4 == 2:
        os.system('cls||clear')
        privetstviye()

def manager_custom_akkov():
    global poslednilog
    os.system('cls||clear')
    print(logo)
    print(f"Последний лог: {poslednilog}\n")
    
    print("[1] Показать все аккаунты | [2] Вернутся назад\n")
    vibor_4 = int(input("Выберите действие: "))
    
    if vibor_4 == 1:
        with open('accs\\manager_accounts_custom.txt', 'r') as file:
            lines = file.readlines()
            for line in lines:
                array = line.split("|")
                print(f'Типа айди: {array[16]} | Ник: {array[13]} | Пароль: {array[14]} | Сервер: {array[12]}')
        print('\n[1] Выставить аккаунт на продажу | [2] Вернутся назад')
        
        vibor_5 = int(input("Выберите действие: "))
        
        if vibor_5 == 1:
            id_akka = input("Введите ТИПА АЙДИ аккаунта (пример Nick_Name127.0.0.1): ")
            with open('accs\\manager_accounts_custom.txt', 'r') as file:
                found = False
                for line_number, line in enumerate(file, 1):
                    if id_akka in line:
                        found = True
                        
                        line = line.replace(" %%0A ", "")
                        line = line.replace(" %0A ", "")
                        line = line.replace("%%0A", "")
                        line = line.replace("%0A", "")
                        
                        line = line.strip()
                        array = line.split("|")
                        
                        print(f"\nАккаунт найден! \nДенег на аккаунте: {array[10]} \nУровень аккаунта: {array[9]} \nАйди скина: {array[11]} \nПривязан ли емейл: {array[1]} \nПривязан ли ВК: {array[0]} \nБизнесы: {array[2]} \nДома: {array[5]} \nМашины: {array[4]} \nТСР: {array[3]} \nОстальную информацию можно увидеть на {line_number} строке в файле manager_accounts.txt\n")
                        print("Пытаюсь залить аккаунт на Samp-Store...")
                        
                        print(f"\nОписание аккаунта на данный момент: {config.get('settings', 'title')}")
                        opisanie = input("Введите описание для аккаунта (0 если не надо менять): ")
                        if opisanie == '0': 
                            opisanie = config.get('settings', 'title')
                        
                        print(f"\nОписание аккаунта на данный момент: {config.get('settings', 'info')}")
                        infoposlepokupki = input("Введите описание после покупки аккаунта (0 если не надо менять): ")
                        if infoposlepokupki == '0': 
                            infoposlepokupki = config.get('settings', 'info')
                        
                        print(f"\nОписание аккаунта на данный момент: {config.get('settings', 'price')}")
                        price = int(input("Введите цену за аккаунт (0 если не надо менять): "))
                        if price == 0: 
                            price = config.get('settings', 'price')
                            
                        print(f"\n Айпи при регистрации аккаунта на данный моментт: {config.get('settings', 'reg_ip')}")
                        reg_ip = input("Введите рег.айпи (0 если не надо менять, 1 если его нет): ")
                        if reg_ip == '0': 
                            reg_ip = config.get('settings', 'reg_ip')
                        if reg_ip == '1':
                            reg_ip = ""
                        
                        print("\nОписание, описание после покупки, цена за аккаунт и рег ип автоматически сохранены!")
                        
                        config.set('settings', 'title', opisanie)
                        config.set('settings', 'info', infoposlepokupki)
                        config.set('settings', 'price', price)
                        if reg_ip == '0':
                            config.set('settings', 'reg_ip', reg_ip)
                        saveini()
                        
                        if array[12].find("7777") != -1:
                            serverr = array[12]
                        else:
                            serverr = (f'{array[12]}:7777')
                            
                        zalit_akk_na_ss(1, array[0], array[1], array[13], array[2], array[3], array[4], array[5], array[6], array[7], array[8], array[9], array[10], array[11], serverr, array[13], array[14], array[15], array[16], price, reg_ip, opisanie, infoposlepokupki)
                        
                        break

                if not found:
                    poslednilog = "Айди такого аккаунта не найден в менеджере кастомных аккаунтов"
                    os.system('cls||clear')
                    privetstviye()

        if vibor_5 == 2:
            os.system('cls||clear')
            privetstviye()
    if vibor_4 == 2:
        os.system('cls||clear')
        privetstviye()

def privetstviye():
    print(logo)
    print("Автор: Haymiritch")
    print("Github: https://github.com/Haymiritch/")
    print("Blast.hk: https://www.blast.hk/members/421795/ \n")
    print(f"Приветствую {socket.gethostname()}! Что хочешь сделать?")
    
    print(f"Последний лог: {poslednilog}")
    print("\n[1] Настройки | [2] Загрузить аккаунты с Samp-Store | [3] Чекер аккаунтов")
    print("[4] Менеджер аккаунтов | [5] Менеджер кастомных аккаунтов\n")
    
    vibor = int(input("Выберите действие: "))
    if vibor == 1:
        settings_script()
    elif vibor == 2:
        zagruzka_akkov_s_ss()
    elif vibor == 3:
        checker_accov()
    elif vibor == 4:
        manager_ss_akkov()
    elif vibor == 5:
        manager_custom_akkov()
    else:
        os.system('cls||clear')
        privetstviye()





config = configparser.ConfigParser()
with open('hermer.ini', 'r', encoding='utf-8') as file:
    config.read_file(file)
    
poslednilog = "пусто"
privetstviye()

# дааа 633 строчки полного без порядка
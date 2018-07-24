﻿Перем WshShell;
Перем КонтекстЯдра;

// { Plugin interface
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Тип", ВозможныеТипыПлагинов.Утилита);
	Результат.Вставить("Идентификатор", Метаданные().Имя);
	Результат.Вставить("Представление", "УправлениеПриложениями");
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
КонецФункции

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
КонецПроцедуры
// } Plugin interface

// { API

// Выполняет команду системы, при этом на экране не будет показано окно cmd
// Использует WshShell.
//
// Параметры:
//  СтрокаКоманды		 - Строка - выполняемая команда
//  ЖдатьОкончания		 - Булево, Число  - флаг ожидания окончания выполнения команды:
//		Если ЖдатьОкончания = Истина (или -1), тогда будет ожидания окончания работы приложения
//		Если ЖдатьОкончания = Ложь (или 0), тогда нет ожидания
//  ИспользоватьКодировкуТекстаUTF8	 - Булево - командный файл будет запущен с кодировкой консоли UTF8 через chcp 65001
//
// Возвращаемое значение:
//   - Результат выполнения скрипта. 0 - если не было ошибок.
//
Функция ВыполнитьКомандуОСБезПоказаЧерногоОкна(Знач ТекстКоманды, Знач ЖдатьОкончания = Истина, 
	Знач ИспользоватьКодировкуТекстаUTF8 = Истина) Экспорт
	
	Если ЖдатьОкончания = -1 Тогда
		ЖдатьОкончания = Истина;
	ИначеЕсли ЖдатьОкончания = 0 Тогда
		ЖдатьОкончания = Ложь;
	КонецЕсли;

	ИмяВременногоФайлаКоманды = ТекстКоманды;
	Если ИспользоватьКодировкуТекстаUTF8 Тогда

		ИмяВременногоФайлаКоманды = ПолучитьИмяВременногоФайла("bat");
		
		//эти две строки нужны для записи файла без BOM
		ЗТ = Новый ЗаписьТекста(ИмяВременногоФайлаКоманды, КодировкаТекста.ANSI, , Ложь);
		ЗТ.Закрыть();

		ЗТ = Новый ЗаписьТекста(ИмяВременногоФайлаКоманды, КодировкаТекста.UTF8, , Истина);
		ЗТ.ЗаписатьСтроку("chcp 65001");
	
		ЗТ.ЗаписатьСтроку(ТекстКоманды);
		ЗТ.Закрыть();
		
		ИмяВременногоФайлаКоманды = """" + ИмяВременногоФайлаКоманды + """";
	КонецЕсли;

	Если WshShell = Неопределено Тогда
		WshShell = ПолучитьWshShell();
	КонецЕсли;

	Рез = WshShell.Run(ИмяВременногоФайлаКоманды, 0, ?(ЖдатьОкончания, -1, 0));

	Если ЖдатьОкончания = -1 и НЕ КонтекстЯдра.ЕстьПоддержкаАсинхронныхВызовов Тогда
		//иначе удалять нельзя
		//КонтекстЯдра.УдалитьФайлыКомандаСистемы(ИмяВременногоФайлаКоманды);
		УдалитьФайлы(ИмяВременногоФайлаКоманды);
	КонецЕсли;	 

	Возврат Рез;
КонецФункции

// далее переменная WshShell будет закеширована, чтобы не создавать ComObject каждый раз
Функция ПолучитьWshShell() Экспорт

	Если WshShell = Неопределено Тогда
		Попытка
			WshShell = Новый COMОбъект("WScript.Shell");
		Исключение
			ВызватьИсключение "Не удалось подключить COM объект <WScript.Shell>";
		КонецПопытки;
	КонецЕсли;

	Возврат WshShell;

КонецФункции

// Функция - Установлен OneScript
// 
// Возвращаемое значение:
//   Булево - Истина = установлен, Ложь = Нет
//
Функция УстановленOneScript() Экспорт

	ИнструментУстановлен = Ложь;

	ИмяФайлаЛога = ПолучитьИмяВременногоФайла("txt");
	Стр = "oscript > """ + ИмяФайлаЛога + """ 2>&1";

	ВыполнитьКомандуОСБезПоказаЧерногоОкна(Стр);

	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяФайлаЛога, "UTF-8");

	СтрокаВозврата = Неопределено;

	КолСтрокСчитано = 0;
	Стр = Текст.ПрочитатьСтроку();

	Если Стр <> Неопределено Тогда
		Образец = "1Script Execution Engine";
		Если Лев(Стр, СтрДлина(Образец)) = Образец Тогда
			ИнструментУстановлен = Истина;
		КонецЕсли;
	КонецЕсли;

	Текст.Закрыть();
	//КонтекстЯдра.УдалитьФайлыКомандаСистемы(ИмяФайлаЛога);
	УдалитьФайлы(ИмяФайлаЛога);

	Возврат ИнструментУстановлен;

КонецФункции // УстановленOneScript()

Функция ПолучитьМассивPIDПроцессов(ИмяОбраза) Экспорт
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	ИмяВременногоBat = ПолучитьИмяВременногоФайла("bat");
	ЗТ = Новый ЗаписьТекста(ИмяВременногоBat, "windows-1251", , Истина);
	ЗТ.ЗаписатьСтроку("chcp 65001");
	ЗТ.ЗаписатьСтроку("tasklist /v /fo list /fi ""imagename eq " + ИмяОбраза + """ > """ + ИмяВременногоФайла + """");
	ЗТ.Закрыть();

	ВыполнитьКомандуОСБезПоказаЧерногоОкна(ИмяВременногоBat);

	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяВременногоФайла, "UTF-8");

	МассивProcessID = Новый Массив;
	ProcessID = Неопределено;
	Пока Истина Цикл
		Стр = Текст.ПрочитатьСтроку();
		Если Стр = Неопределено Тогда
			Прервать;
		КонецЕсли;

		Стр = НРег(Стр);
		Если Лев(Стр, 4) = "pid:" Тогда
			ProcessID = СокрЛП(Сред(Стр, 5));
		КонецЕсли;

		Если ProcessID <> Неопределено Тогда
			Если (Лев(Стр, 15) = "заголовок окна:") или (Лев(Стр, 13) = "window title:") Тогда
				МассивProcessID.Добавить(ProcessID);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Текст.Закрыть();

	Возврат МассивProcessID;
КонецФункции

Процедура ЗавершитьСеансыTestClientПринудительно() Экспорт
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");

	Если НЕ КонтекстЯдра.ЭтоLinux Тогда
		ИмяВременногоBat = ПолучитьИмяВременногоФайла("bat");
		ЗТ = Новый ЗаписьТекста(ИмяВременногоBat, "windows-1251", , Истина);
		ЗТ.ЗаписатьСтроку("chcp 65001");
		ЗТ.ЗаписатьСтроку("tasklist /v /fo list /fi ""imagename eq 1cv8c.exe"" > """ + ИмяВременногоФайла + """");
		ЗТ.Закрыть();

		ЗапуститьПриложение(ИмяВременногоBat, , Истина);

		Текст = Новый ЧтениеТекста;
		Текст.Открыть(ИмяВременногоФайла, "UTF-8");

		МассивProcessID = Новый Массив;
		ProcessID = Неопределено;
		Пока Истина Цикл
			Стр = Текст.ПрочитатьСтроку();
			Если Стр = Неопределено Тогда
				Прервать;
			КонецЕсли;

			Стр = НРег(Стр);
			Если Лев(Стр, 4) = "pid:" Тогда
				ProcessID = СокрЛП(Сред(Стр, 5));
			КонецЕсли;

			Если ProcessID <> Неопределено Тогда
				Если (Лев(Стр, 15) = "заголовок окна:") или (Лев(Стр, 13) = "window title:") Тогда
					Если Найти(Стр, "vanessa") = 0 Тогда
						МассивProcessID.Добавить(ProcessID);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Текст.Закрыть();

		Если МассивProcessID.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;

		ИмяВременногоBat = ПолучитьИмяВременногоФайла("bat");
		ЗТ = Новый ЗаписьТекста(ИмяВременногоBat, "UTF-8", , Истина);
		Стр = "taskkill /F ";
		Для каждого ProcessID Из МассивProcessID Цикл
			Стр = Стр + "/pid " + ProcessID + " ";
		КонецЦикла;
		ЗТ.ЗаписатьСтроку(Стр);
		ЗТ.Закрыть();

		ЗапуститьПриложение(ИмяВременногоBat, , Истина);

	Иначе

		СтрокаЗапуска = "kill -9 `ps aux | grep -ie TESTCLIENT | grep -ie 1cv8c | awk '{print $2}'`";
		ЗапуститьПриложение(СтрокаЗапуска);

	КонецЕсли;

КонецПроцедуры

Функция ПолучитьМассивPIDОкон1С() Экспорт
	Рез = Новый Массив;

	ЗаполнитьМассивPIDПоИмениПроцесса("1cv8.exe", Рез);
	ЗаполнитьМассивPIDПоИмениПроцесса("1cv8c.exe", Рез);

	Возврат Рез;

КонецФункции

Процедура СделатьОкноПроцессаАктивным(PID) Экспорт
	WshShell = ПолучитьWshShell();

	Попытка
		WshShell.AppActivate(PID);
	Исключение
		КонтекстЯдра.СделатьСообщение(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

Процедура TASKKILL(ИмяПриложения) Экспорт
	СтрокаКоманды = "TASKKILL /F /IM " + ИмяПриложения;
	ВыполнитьКомандуОСБезПоказаЧерногоОкна(СтрокаКоманды);
КонецПроцедуры


// } Plugin interface

// { Helpers

Процедура ЗаполнитьМассивPIDПоИмениПроцесса(ИмяПроцесса, Массив)
	ЛогФайл = ПолучитьИмяВременногоФайла("txt");
	Команда = "tasklist /FI ""IMAGENAME eq " + ИмяПроцесса +  """ /nh > """ + ЛогФайл + """";
	ВыполнитьКомандуОСБезПоказаЧерногоОкна(Команда);

	Файл = Новый Файл(ЛогФайл);
	Если Не Файл.Существует() Тогда
		КонтекстЯдра.СделатьСообщение("Ошибка при получении списка процессов 1С. ЗаполнитьМассивPIDПоИмениПроцесса");
		Возврат;
	КонецЕсли; 
		//Если НЕ КонтекстЯдра.ФайлСуществуетКомандаСистемы(ЛогФайл, "ЗаполнитьМассивPIDПоИмениПроцесса") Тогда
		//	КонтекстЯдра.СделатьСообщение("Ошибка при получении списка процессов 1С.");
		//	Возврат;
		//КонецЕсли;

	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ЛогФайл, "UTF-8");

	Пока Истина Цикл
		Стр = Текст.ПрочитатьСтроку();
		Если Стр = Неопределено Тогда
			Прервать;
		КонецЕсли;


		Если СокрЛП(Стр) = "" Тогда
			Продолжить;
		КонецЕсли;

		Стр = НРег(Стр);
		Стр = СокрЛП(СтрЗаменить(Стр, НРег(ИмяПроцесса), ""));
		Поз = Найти(Стр, " ");
		PID = Лев(Стр, Поз - 1);
		Если Найти(PID,"info") > 0 Тогда
			Продолжить;
		КонецЕсли;

		Попытка
			PID = Число(PID);
			Массив.Добавить(PID);
		Исключение
			ТекстСообщения = "Не смог преобразовать к числу PID=%1";
			ТекстСообщения = СтрЗаменить(ТекстСообщения,"%1",PID);
			КонтекстЯдра.СделатьСообщение(ТекстСообщения);
		КонецПопытки;

	КонецЦикла;

	Текст.Закрыть();

	УдалитьФайлы(ЛогФайл);
	//КонтекстЯдра.УдалитьФайлыКомандаСистемы(ЛогФайл);

КонецПроцедуры

// } Helpers
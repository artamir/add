﻿#Область ОписаниеПеременных

Перем КонтекстЯдра;
Перем Ожидаем;
Перем Утверждения;
Перем ГенераторТестовыхДанных;
Перем ЗапросыИзБД;
Перем УтвержденияПроверкаТаблиц;
Перем СтроковыеУтилиты;
Перем Данные;

Перем ФабрикаСоздателей;

#Область Создатель

Перем ПутьДанныхСоздателя;

#КонецОбласти

#Область ФабрикаСоздателей

Перем СооответствиеВидовМетаданных;

#КонецОбласти

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ИнтерфейсТестирования

//{ основные процедуры для юнит-тестирования xUnitFor1C

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	ГенераторТестовыхДанных = КонтекстЯдра.Плагин("СериализаторMXL");
	ЗапросыИзБД = КонтекстЯдра.Плагин("ЗапросыИзБД");
	УтвержденияПроверкаТаблиц = КонтекстЯдра.Плагин("УтвержденияПроверкаТаблиц");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	Данные = КонтекстЯдра.Плагин("Данные");
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	//НаборТестов.Добавить("ПараметрическийТест", НаборТестов.ПараметрыТеста(5, 7), "Тест должен показать использование представления теста");
		//Тест = НаборТестов.Добавить("ПараметрическийТест2");
		//Тест.Параметры.Добавить(12);
	НаборТестов.НачатьГруппу("Подключения Создателя к плагину Данные", Ложь);
		НаборТестов.Добавить("ТестПроверяетПодключениСоздателяКПлагинуДанные");
		
	НаборТестов.НачатьГруппу("АПИ Создателя", Ложь);
		НаборТестов.Добавить("ТестСоздаетДанныеЧерезСоздателя");
		НаборТестов.Добавить("ТестСоздаетДанныеЧерезСоздателяДобавляяРеквизиты");
		
	НаборТестов.НачатьГруппу("Подключение создателей через фабрику", Ложь);
		НаборТестов.Добавить("ТестПодключаетСоздателяКФабрикеСоздателей");
		НаборТестов.Добавить("ТестПодключаетСоздателяКФабрикеСоздателейЯвноУказываюПутьДанных");
		НаборТестов.Добавить("ТестИсключаетНеверногоСоздателяКФабрикеСоздателей");
		НаборТестов.Добавить("ТестПолучаетСоздателяЧерезЕдинственноеЧислоМетаданного");
		НаборТестов.Добавить("ТестПолучаетСоздателяЧерезМножественноеЧислоМетаданного");
		
	НаборТестов.НачатьГруппу("Сложные тесты", Ложь);
		НаборТестов.Добавить("ТесСоздаетДокументСДвижениямиПлюсНеобходимыеСправочники");
		
КонецПроцедуры
//}

#КонецОбласти

#Область Тесты

//{ блок юнит-тестов - сами тесты

Процедура ПередЗапускомТеста() Экспорт
	НачатьТранзакцию();
	
	ПутьДанныхСоздателя = "Справочник.Справочник1";
	
	ФабрикаСоздателей = НоваяФабрикаСоздателей();
	ОбъектСоздатель = ПодключитьСоздателя(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	Если ТранзакцияАктивна() Тогда
		ОтменитьТранзакцию();
	КонецЕсли; 
КонецПроцедуры

Процедура ТестПроверяетПодключениСоздателяКПлагинуДанные() Экспорт
	
	ПроверяетПодключениСоздателяКПлагинуДанные(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПроверяетПодключениСоздателяКПлагинуДанные(Создатель) Экспорт
	
	//Справочник1 = Данные.Создатель(Создатель("Справочник.Справочник1"))
	Справочник1 = Данные.Создатель(Создатель)
		.Реквизит("РеквизитСтрока", "Строка1")
		.Создать();	
		
	Ожидаем.Что(Справочник1.Реквизит1, "Справочник1.Реквизит1").
		Равно(Перечисления.Перечисление1.ЗначениеПеречисления2);

	Ожидаем.Что(Справочник1.Наименование, "Справочник1.Наименование")
		.Содержит("_");
	//Ожидаем.Что(Справочник1.Наименование, "Справочник1.Наименование")
	//	.Равно("123");
	
КонецПроцедуры

Процедура ТестСоздаетДанныеЧерезСоздателя() Экспорт
	
	Справочник1 = Создатель("Справочник.Справочник1")
		.Создать();	
		
	Ожидаем.Что(Справочник1, "Справочник1")
		.ИмеетТип("СправочникОбъект.Справочник1");

	Ожидаем.Что(Справочник1.Реквизит1, "Справочник1.Реквизит1")
		.Равно(Перечисления.Перечисление1.ЗначениеПеречисления2);

	Ожидаем.Что(Справочник1.Наименование, "Справочник1.Наименование")
		.Равно("");
	
КонецПроцедуры

Процедура ТестСоздаетДанныеЧерезСоздателяДобавляяРеквизиты() Экспорт
	
	ОкружениеТеста = Новый Структура ();
    ОкружениеТеста.Вставить("Наименование", "123");
    ОкружениеТеста.Вставить("Реквизит1", Перечисления.Перечисление1.ЗначениеПеречисления1);
	
	Справочник1 = Создатель("Справочник.Справочник1")
		.Создать(ОкружениеТеста);	
		
	Ожидаем.Что(Справочник1, "Справочник1")
		.ИмеетТип("СправочникОбъект.Справочник1");

	Ожидаем.Что(Справочник1.Реквизит1, "Справочник1.Реквизит1")
		.Равно(Перечисления.Перечисление1.ЗначениеПеречисления1);

	Ожидаем.Что(Справочник1.Наименование, "Справочник1.Наименование")
		.Равно("123");
	
КонецПроцедуры

Процедура ТестПодключаетСоздателяКФабрикеСоздателей() Экспорт
	
	ФабрикаСоздателей = НоваяФабрикаСоздателей();
	ОбъектСоздатель = ПодключитьСоздателя(ЭтотОбъект);
	
	НовыйСоздатель = Создатель("Справочник.Справочник1");
	
	Ожидаем.Что(НовыйСоздатель, "НовыйСоздатель == ОбъектСоздатель")
		.Равно(ОбъектСоздатель);
	
	ПроверяетПодключениСоздателяКПлагинуДанные(НовыйСоздатель);
	
КонецПроцедуры

Процедура ТестПодключаетСоздателяКФабрикеСоздателейЯвноУказываюПутьДанных() Экспорт
	
	ФабрикаСоздателей = НоваяФабрикаСоздателей();
	ОбъектСоздатель = ПодключитьСоздателя(ЭтотОбъект, "Справочник.Справочник1");
	
	НовыйСоздатель = Создатель("Справочник.Справочник1");
	
	Ожидаем.Что(НовыйСоздатель, "НовыйСоздатель == ОбъектСоздатель")
		.Равно(ОбъектСоздатель);
	
	ПроверяетПодключениСоздателяКПлагинуДанные(НовыйСоздатель);
	
КонецПроцедуры

Процедура ТестПолучаетСоздателяЧерезЕдинственноеЧислоМетаданного() Экспорт
	
	ФабрикаСоздателей = НоваяФабрикаСоздателей();
	ОбъектСоздатель = ПодключитьСоздателя(ЭтотОбъект, "Справочник.Справочник1");
	
	НовыйСоздатель = Создатель("Справочники.Справочник1");
	
	Ожидаем.Что(НовыйСоздатель, "НовыйСоздатель == ОбъектСоздатель")
		.Равно(ОбъектСоздатель);
	
	ПроверяетПодключениСоздателяКПлагинуДанные(НовыйСоздатель);
	
КонецПроцедуры

Процедура ТестПолучаетСоздателяЧерезМножественноеЧислоМетаданного() Экспорт
	
	ФабрикаСоздателей = НоваяФабрикаСоздателей();
	ОбъектСоздатель = ПодключитьСоздателя(ЭтотОбъект, "Справочники.Справочник1");
	
	НовыйСоздатель = Создатель("Справочник.Справочник1");
	
	Ожидаем.Что(НовыйСоздатель, "НовыйСоздатель == ОбъектСоздатель")
		.Равно(ОбъектСоздатель);
	
	ПроверяетПодключениСоздателяКПлагинуДанные(НовыйСоздатель);
	
КонецПроцедуры

Процедура ТестИсключаетНеверногоСоздателяКФабрикеСоздателей() Экспорт
	
	ФабрикаСоздателей = НоваяФабрикаСоздателей();
	ОбъектСоздатель = ПодключитьСоздателя(ЭтотОбъект, "Справочник.Справочник1");
	
	Ожидаем.Что(ЭтотОбъект, "НовыйСоздатель == Неопределено")
		.Метод("Создатель", "Справочник.Справочник2")
		.ВыбрасываетИсключение("Не удалось найти создателя данных по пути Справочник.Справочник2");
	
	//НовыйСоздатель = Создатель("Справочник.Справочник2");
	//Ожидаем.Что(НовыйСоздатель, "НовыйСоздатель == Неопределено")
	//	.Равно(Неопределено);
	
КонецПроцедуры

Процедура ТесСоздаетДокументСДвижениямиПлюсНеобходимыеСправочники() Экспорт
	
	#Область Окружение
	
	ИД = 14;
	
	Окружение = Новый Структура;
	Окружение.Вставить("ИД", ИД);
	Окружение.Вставить("Дата", ТекущаяДатаСеанса() - 100);
	
	Простой1 = Новый Структура("Наименование, РеквизитПеречисление", "Простой " + ИД, Перечисления.Перечисление1.ЗначениеПеречисления2);
	Окружение.Вставить("ПростойСправочник", Простой1);
	
	Простой2 = Новый Структура("Наименование", "Простой 2 " + ИД);
	//Простой2 = Новый Структура("Наименование, Счет", "Простой 2 " + ИД, ПланыСчетов.ПланСчетов1.Счет02);
	Окружение.Вставить("ПростойСправочник2", Простой2);
	
	МассивТабЧасти = Новый Массив;
	
	СтрокаТЧ = Новый Структура;
	СтрокаТЧ.Вставить("Реквизит1", "реквизит 10 11 " + ИД);
	СтрокаТЧ.Вставить("РесурсЧисло", 10);
	СтрокаТЧ.Вставить("РесурсЧисло1", 11);
	МассивТабЧасти.Добавить(СтрокаТЧ);

	СтрокаТЧ = Новый Структура;
	СтрокаТЧ.Вставить("Реквизит1", "реквизит 20 21 " + ИД);
	СтрокаТЧ.Вставить("РесурсЧисло", 20);
	СтрокаТЧ.Вставить("РесурсЧисло1", 21);
	МассивТабЧасти.Добавить(СтрокаТЧ);
	
	Окружение.Вставить("Состав", МассивТабЧасти);
	
	#КонецОбласти
	
	#Область ПодключениеСоздателей
	
	ПодключитьСоздателя(НовыйСоздатель("Справочник.ПростойСправочник"));
	ПодключитьСоздателя(НовыйСоздатель("Справочник.ПростойСправочник2"));
	
	ПодключитьСоздателя(НовыйСоздатель("Документ.ДокументСДвижениями"));
	ПодключитьСоздателя(НовыйСоздатель("Документ.ДокументСДвижениями.ТЧ"));
	
	#КонецОбласти
	
	#Область СозданиеДанных
	
	СоздательПростой1 = Создатель("Справочник.ПростойСправочник");
	П = СоздательПростой1.Параметры(Окружение.ПростойСправочник);
	ПростойСправочник = СоздательПростой1.Создать(Окружение.ПростойСправочник);
	
	СоздательПростой2 = Создатель("Справочник.ПростойСправочник2");
	П = СоздательПростой2.Параметры(Окружение.ПростойСправочник2);
	ПростойСправочник2 = СоздательПростой2.Создать(П);
	
	СоздательТабЧастиДокументаСДвижениями = Создатель("Документ.ДокументСДвижениями.ТЧ");
	
	ТабЧасть = Новый Массив;
	Для Каждого ОписаниеСтрокиТЧ Из Окружение.Состав Цикл
		НоваяСтрокаТЧ = СоздательТабЧастиДокументаСДвижениями.Параметры(ОписаниеСтрокиТЧ);
		ТабЧасть.Добавить(НоваяСтрокаТЧ);
	КонецЦикла;
	
	СоздательДокументаСДвижениями = Создатель("Документ.ДокументСДвижениями");
	П = СоздательДокументаСДвижениями.Параметры();
	П.Вставить("Дата", Окружение.Дата);
	//П.Вставить("Проведен", Окружение.Дата);
	П.Вставить("РеквизитПростойСправочник", ПростойСправочник.Ссылка);
	П.Вставить("РеквизитПростойСправочник2", ПростойСправочник2.Ссылка);
	П.Вставить("ТабЧасть", ТабЧасть);
	
	СозданныйДокумент = СоздательДокументаСДвижениями.Создать(П);
		
	#КонецОбласти
	
	#Область Проверка
		
	Ожидаем.Что(СозданныйДокумент, "СозданныйДокумент")
		.ИмеетТип("ДокументОбъект.ДокументСДвижениями");

	Ожидаем.Что(СозданныйДокумент.Дата, "СозданныйДокумент.Дата")
		.Равно(Окружение.Дата);

	Ожидаем.Что(СозданныйДокумент.РеквизитПростойСправочник, "СозданныйДокумент.РеквизитПростойСправочник")
		.Равно(ПростойСправочник.Ссылка);

	Ожидаем.Что(СозданныйДокумент.РеквизитПростойСправочник.РеквизитПеречисление, "СозданныйДокумент.РеквизитПростойСправочник.РеквизитПеречисление")
		.Равно(Перечисления.Перечисление1.ЗначениеПеречисления2);

	Ожидаем.Что(СозданныйДокумент.РеквизитПростойСправочник2, "СозданныйДокумент.РеквизитПростойСправочник2")
		.Равно(ПростойСправочник2.Ссылка);

	//Ожидаем.Что(СозданныйДокумент.РеквизитПростойСправочник2.Счет, "СозданныйДокумент.РеквизитПростойСправочник2.Счет")
	//	.Равно(ПланыСчетов.ПланСчетов1.Счет02);
		
	Ожидаем.Что(СозданныйДокумент.Проведен, "СозданныйДокумент.Проведен")
		.Равно(Истина);

	Ожидаем.Что(СозданныйДокумент.ТЧ.Количество(), "СозданныйДокумент.ТЧ.Количество()")
		.Равно(2);
		
	Ожидаем.Что(СозданныйДокумент.ТЧ.Итог("РесурсЧисло"), "СозданныйДокумент.Итог(РесурсЧисло)")
		.Равно(30);

	Ожидаем.Что(СозданныйДокумент.ТЧ.Итог("РесурсЧисло1"), "СозданныйДокумент.Итог(РесурсЧисло1)")
		.Равно(32);
	
	#КонецОбласти
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Создатель

#Область ФабрикаСоздателей

// Подключить создателя. Если путь данных явно не задан, он получается из создателя
//
// Параметры:
//  ОбъектСоздатель	 - Произвольный - 
//  ИерархияДанных	 - Строка	 - 
// 
// Возвращаемое значение:
//   Произвольный - подключаемый создатель
//
Функция ПодключитьСоздателя(Знач ОбъектСоздатель, Знач ИерархияДанных = "") Экспорт
	
	Если ПустаяСтрока(ИерархияДанных) Тогда
		ИерархияДанных = ОбъектСоздатель.ТипВидМетаданного();
	КонецЕсли;
	НормализованныйПуть = НормализованныйПуть(ИерархияДанных);
	
	ФабрикаСоздателей.Вставить(НормализованныйПуть, ОбъектСоздатель);
	
	Возврат ОбъектСоздатель;
	
КонецФункции

// Получить создателя по пути к данным вида "Справочник.Справочник1"
//
// Параметры:
//  ПутьДанных	 - Строка - 
// 
// Возвращаемое значение:
//   Произвольный, Неопределено - найденный создатель
//
Функция Создатель(Знач ПутьДанных) Экспорт
	
	НормализованныйПуть = НормализованныйПуть(ПутьДанных);
	
	Результат = ФабрикаСоздателей.Получить(НормализованныйПуть);
	Если Результат = Неопределено Тогда
		ВызватьИсключение "Не удалось найти создателя данных по пути " + ПутьДанных;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Нормализованный путь - приводит разные имена Справочник.ХХХ, Справочники.ХХХ и т.п.
// 	в единый формат единственного числа Справочник.ХХХ, Документ.ХХХХ и т.п.
// 
// Возвращаемое значение:
//   Строка - имя метаданного в единственном числе Справочник.ХХХ, Документ.ХХХ и т.п. 
//
Функция НормализованныйПуть(Знач ПутьДанных) Экспорт
	
	ГдеИскать = СооответствиеВидовМетаданных();
	Для Каждого КлючЗначение Из ГдеИскать Цикл
		Если Найти(ПутьДанных, КлючЗначение.Ключ) = 1 Тогда
			Описание = КлючЗначение.Значение;
			Возврат Описание.Значение + Сред(ПутьДанных, Описание.Длина + 1);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПутьДанных;
	
КонецФункции

Функция НоваяФабрикаСоздателей()
	Результат = Новый Соответствие;
	Возврат Результат;
КонецФункции

Функция СооответствиеВидовМетаданных()
	
	Если ЗначениеЗаполнено(СооответствиеВидовМетаданных) Тогда
		Возврат СооответствиеВидовМетаданных;
	КонецЕсли;
	
	П = Новый Соответствие;
	П.Вставить("Справочник", "Справочники");
	П.Вставить("Документ", "Документы");
	П.Вставить("БизнесПроцесс", "БизнесПроцессы");
	П.Вставить("Задача", "Задачи");
	П.Вставить("Константа", "Константы");
	П.Вставить("РегистрСведений", "РегистрыСведений");
	П.Вставить("РегистрНакопления", "РегистрыНакопления");
	П.Вставить("РегистрБухгалтерии", "РегистрыБухгалтерии");
	П.Вставить("РегистрРасчета", "РегистрыРасчета");
	П.Вставить("ПланСчетов", "ПланыСчетов");
	П.Вставить("ПланВидовХарактеристик", "ПланыВидовХарактеристик");
	
	Результат = Новый Соответствие;
	Для Каждого КлючЗначение Из П Цикл
		КлючСТочкой = КлючЗначение.Ключ + ".";
		КлючСТочкойВРег = ВРег(КлючСТочкой);
		
		Описание = Новый Структура("Значение, Длина", КлючСТочкойВРег, СтрДлина(КлючСТочкой));
		Результат.Вставить(КлючСТочкой, Описание);
		
		ЗначениеСТочкой = КлючЗначение.Значение + ".";
		
		Описание = Новый Структура("Значение, Длина", КлючСТочкойВРег, СтрДлина(ЗначениеСТочкой));
		Результат.Вставить(КлючЗначение.Значение + ".", Описание);
	КонецЦикла;
	
	СооответствиеВидовМетаданных = Новый ФиксированноеСоответствие(Результат);
	
	Возврат СооответствиеВидовМетаданных;
	
КонецФункции

#КонецОбласти

#Область Интерфейс_Создатель

// Указать путь создаваемого метаданного - Справочники.Склады, Документы.Реализация и т.п.
// 
// Возвращаемое значение:
//   Строка - 
//
Функция ТипВидМетаданного() Экспорт
	
	Возврат ПутьДанныхСоздателя;

КонецФункции

// Задать параметры по умолчанию для создания метаданного
// 	Можно добавлять доп.структуру ОбменДанными с Загрузка = Истина
//
// Параметры:
//  ДопПараметры - Неопределено, Структура	 - доп.параметры для установки
// 
// Возвращаемое значение:
//   Структура - ключ - имя реквизита метаданного, значение - его значения
//
Функция Параметры(Знач ДопПараметры = Неопределено) Экспорт
    
    Р = Новый Структура ();
	
	УстановитьПараметры(Р, ПутьДанныхСоздателя);
	
	Если Не Р.Свойство("Проведен") Или Не Р.Проведен Тогда
    	Р.Вставить ("ОбменДанными", Новый Структура("Загрузка", Истина));
	КонецЕсли;
    
    Если ЗначениеЗаполнено(ДопПараметры) Тогда
        Для Каждого КлючЗначение Из ДопПараметры Цикл
            Р.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
        КонецЦикла;
    КонецЕсли;

    Возврат Р;

КонецФункции

// Создать нужный элемент, документ, набор записей и т.п.
//
// Параметры:
//  Параметры	 - Структура	 - 
// 		Может быть вложенная структура ОбменДанными, с ключом Загрузка
// 
// Возвращаемое значение:
//   Произвольный, СправочникОбъект, ДокументОбъект, НаборЗаписей - созданный и записанный элемент
//
Функция Создать(Знач Параметры = Неопределено) Экспорт
    
    Если Не ЗначениеЗаполнено(Параметры) Тогда
        Параметры = Параметры();
	КонецЕсли;
	
	НовыйЭлемент = СоздатьДляТеста(Параметры, ПутьДанныхСоздателя);

    ЗаполнитьЗначенияСвойств(НовыйЭлемент, Параметры);

    Если Параметры.Свойство("ОбменДанными") Тогда
        ЗаполнитьЗначенияСвойств(НовыйЭлемент.ОбменДанными, Параметры.ОбменДанными);
    КонецЕсли;

    НовыйЭлемент.Записать();

    Возврат НовыйЭлемент;

КонецФункции

// Установить путь данных. Необязательно. Обычно создатель сам знает, какие данные он создает
//
// Параметры:
//  ПутьДанных	 - Строка - путь данных Справочники.Склады, Документы.Реализация и т.п.  
//
Процедура УстановитьПутьДанных(Знач ПутьДанных) Экспорт
	
	ПутьДанныхСоздателя = ПутьДанных;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Настройки

Процедура Настройки(мКонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ПлагинНастроек = мКонтекстЯдра.Плагин("Настройки");
	Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

Функция ИмяТеста()
	Возврат Метаданные().Имя;
КонецФункции

Функция ВыполнятьТест(КонтекстЯдра)
	
	ПутьНастройки = КлючНастройки();
	Настройки(КонтекстЯдра, ПутьНастройки);
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ИмяТеста = ИмяТеста();
	
	ВыполнятьТест = Истина;
	Если ТипЗнч(Настройки) = Тип("Структура") 
		И Настройки.Свойство("Параметры") 
		И Настройки.Параметры.Свойство(ИмяТеста) Тогда

			ВыполнятьТест = Настройки.Параметры[ИмяТеста];	
	КонецЕсли;
	
	Возврат ВыполнятьТест;

КонецФункции

Функция КлючНастройки()
	Возврат ИмяТеста();	
КонецФункции

#Область Создатель_Служебные

Функция НовыйСоздатель(Знач ПутьДанных)
	
	Объект = ВнешниеОбработки.Создать(ИмяТеста());
	Объект.УстановитьПутьДанных(ПутьДанных);
	Возврат Объект;
	
КонецФункции

Процедура УстановитьПараметры(Параметры, Знач ПутьДанных)

	Если ПутьДанных = "Справочник.Справочник1" Тогда
		
		Параметры.Вставить("Наименование");
	    Параметры.Вставить("Реквизит1", Перечисления.Перечисление1.ЗначениеПеречисления2);
		
	ИначеЕсли ПутьДанных = "Справочник.ПростойСправочник" Тогда
		
		Параметры.Вставить("Наименование");
	    Параметры.Вставить("РеквизитБулево", Истина);
	    Параметры.Вставить("РеквизитПеречисление", Перечисления.Перечисление1.ЗначениеПеречисления1);
		
	ИначеЕсли ПутьДанных = "Справочник.ПростойСправочник2" Тогда
		
		Параметры.Вставить("Наименование");
	    Параметры.Вставить("РеквизитБулево", Истина);
		//Параметры.Вставить("Счет", ПланыСчетов.ПланСчетов1.Счет01);

	ИначеЕсли ПутьДанных = "Документ.ДокументСДвижениями" Тогда
		
		Параметры.Вставить("Дата", ТекущаяДатаСеанса());
		Параметры.Вставить("Проведен", Истина);
		Параметры.Вставить("ПометкаУдаления", Ложь);
		
		Параметры.Вставить("ТабЧасть", Новый Массив);
		
		Параметры.Вставить("РеквизитПростойСправочник", Справочники.ПростойСправочник.ПредопределенноеЗначение1);
		//Параметры.Вставить("РеквизитПростойСправочник", Справочники.ПростойСправочник2.);

	ИначеЕсли ПутьДанных = "Документ.ДокументСДвижениями.ТЧ" Тогда
		
		Параметры.Вставить("Реквизит1", "ТестСтрока1");
		Параметры.Вставить("РесурсЧисло", 21);
		Параметры.Вставить("РесурсЧисло1", 11);
		
	Иначе
		ВызватьИсключение "Еще не умеем устанавливать параметры для пути " + ПутьДанных;
	КонецЕсли;
	
КонецПроцедуры

Функция СоздатьДляТеста(Параметры, Знач ПутьДанных)

	Если ПутьДанных = "Справочник.Справочник1" Тогда
		
    	НовыйЭлемент = Справочники.Справочник1.СоздатьЭлемент();
		
	ИначеЕсли ПутьДанных = "Справочник.ПростойСправочник" Тогда
		
    	НовыйЭлемент = Справочники.ПростойСправочник.СоздатьЭлемент();
		
	ИначеЕсли ПутьДанных = "Справочник.ПростойСправочник2" Тогда
		
	    НовыйЭлемент = Справочники.ПростойСправочник2.СоздатьЭлемент();

	ИначеЕсли ПутьДанных = "Документ.ДокументСДвижениями" Тогда
		
	    НовыйЭлемент = Документы.ДокументСДвижениями.СоздатьДокумент();
		
		Для Каждого ОписаниеСтроки Из Параметры.ТабЧасть Цикл
			НоваяСтрока = НовыйЭлемент.ТЧ.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ОписаниеСтроки);
		КонецЦикла;

	ИначеЕсли ПутьДанных = "Документ.ДокументСДвижениями.ТЧ" Тогда
				
	Иначе
		ВызватьИсключение "Еще не умеем устанавливать параметры для пути " + ПутьДанных;
	КонецЕсли;
	
	Возврат НовыйЭлемент;
	
КонецФункции

#КонецОбласти 

#КонецОбласти

Функция ТекстСообщения(Результат)

	ШаблонСообщения = НСтр("ru = '!!! Заменить на свой текст: %1%2'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, Символы.ПС, Результат);
	
	Возврат ТекстСообщения;

КонецФункции

Функция ОбработатьОтносительныйПуть(Знач ОтносительныйПуть, КонтекстЯдра)

	Если Лев(ОтносительныйПуть, 1) = "." И ЗначениеЗаполнено(КонтекстЯдра.Объект.КаталогПроекта) Тогда
		ОтносительныйПуть = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
								"%1%2", 
								КонтекстЯдра.Объект.КаталогПроекта, 
								Сред(ОтносительныйПуть, 2));
	КонецЕсли;
	
	Результат = СтрЗаменить(ОтносительныйПуть, "\\", "\");
		
	Возврат Результат;

КонецФункции 

#КонецОбласти

//} 


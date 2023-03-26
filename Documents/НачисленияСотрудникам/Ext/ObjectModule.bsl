﻿
Процедура ОбработкаПроведения(Отказ, Режим)     
	
	// регистр Начисления
	Движения.Начисления.Записывать = Истина;
	Для Каждого ТекСтрокаНачисления Из Начисления Цикл
		Движение = Движения.Начисления.Добавить();
		Движение.Сторно = Ложь;
		Движение.ВидРасчета = ТекСтрокаНачисления.ВидРасчета;
		Движение.ПериодДействияНачало = ТекСтрокаНачисления.ДатаНачала;
		Движение.ПериодДействияКонец = КонецДня(ТекСтрокаНачисления.ДатаОкончания);
		Движение.ПериодРегистрации = Дата;
		Движение.БазовыйПериодНачало = ТекСтрокаНачисления.ДатаНачала;
		Движение.БазовыйПериодКонец = КонецДня(ТекСтрокаНачисления.ДатаОкончания);
		Движение.Сотрудник = ТекСтрокаНачисления.Сотрудник;
		Движение.ГрафикРаботы = ТекСтрокаНачисления.ГрафикРаботы;
		Движение.ИсходныеДанные = ТекСтрокаНачисления.Начислено;
	КонецЦикла;   
	
	// Записываем движения регистров
	Движения.Начисления.Записать();       
	
	// Получим список всех сотрудников, содержащихся в документе
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	| НачисленияСотрудникамНачисления.Сотрудник
	|ИЗ
	| Документ.НачисленияСотрудникам.Начисления КАК НачисленияСотрудникамНачисления
	|
	|ГДЕ
	| НачисленияСотрудникамНачисления.Ссылка = &ТекущийДокумент"); 
	
	Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
	
	// Сформируем список сотрудников
	ТаблЗнач = Запрос.Выполнить().Выгрузить();
	МассивСотрудников = ТаблЗнач.ВыгрузитьКолонку("Сотрудник");
	
	// Вызов процедуры РассчитатьНачисления из общего модуля
	ПроведениеРасчетов.РассчитатьНачисления(Движения.Начисления, 
	ПланыВидовРасчета.ОсновныеНачисления.Оклад, МассивСотрудников);
	Движения.Начисления.Записать( , Истина);
	ПроведениеРасчетов.РассчитатьНачисления(Движения.Начисления, ПланыВидовРасчета.
	ОсновныеНачисления.Премия, МассивСотрудников);
	Движения.Начисления.Записать( , Истина);

КонецПроцедуры

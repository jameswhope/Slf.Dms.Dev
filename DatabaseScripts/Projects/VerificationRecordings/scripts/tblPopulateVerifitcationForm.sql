	 
	 /* Delete From tblVerificationQuestion Where VersionId = 1
 
	 Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('Can you confirm that you have read the legal services agreement between you and the Law Firm?', '¿Puede confirmar que usted ha leído el acuerdo legal de servicio entre usted y el Bufete de abogados?',1)
	 
	  Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP, [Order])
	 Values ('The legal services agreement is for the Law Firm to represent you in certain claims made by your creditors and to attempt to negotiate a settlement of those claims – is that your understanding?', 'El acuerdo legal de servicios es del Bufete de Abogados para representarle en ciertos reclamos hechos por acreedores y para procurar negociar un arreglo de esos reclamos - ¿Es eso su comprensión?',2)
	 
	  Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP, [Order])
	 Values ('The Law Firm is a {state} based firm and is not licensed to practice law in other states except when their laws allow it to do so – is that your understanding?', 'El Bufete de Abogados es una firma basada en {state} y no es licenciado para practicar ley en otros estados al menos cuando sus leyes lo permiten hacer así- ¿Es eso su comprensión?',3)
	 
	  Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('The Law Firm has associate attorneys in your state who are available for consultation with you – is that your understanding?', 'El Bufete de abogados tiene abogados asociados en su estado que están disponibles para la consulta con usted - ¿Es eso su comprensión?', 4)
	 
	  Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP, [Order])
	 Values ('The outcome of settlements on accounts listed with the Law Firm cannot be guaranteed and that any settlement is the result of unpredictable negotiation – is that your understanding?', 'El resultado de arreglos de cuentas alistadas con el Bufete de abogados no puede ser garantizado y que cualquier arreglo es el resultado de negociación imprevisible - ¿Es eso su comprensión?', 5)
	 
	  Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP, [Order])
	 Values ('Although we can give you an estimate, no guarantees of any kind can be made of any specific result – is that your understanding?', 'Aunque nosotros le podamos dar un estimado, ningúna garantia de cualquier tipo pueden ser hecha de cualquier resultado específico-¿Es eso su comprensión? ', 6)
	 
	  Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('We also want to confirm that you are aware you are entering a debt negotiation process administered by the Law Firm. Do you understand that the Law Firm is not a Credit Counseling Company or Debt Consolidator, and that it will not be making monthly payments to your creditors?', 'Nosotros también queremos confirmar que usted está enterado que usted entra a un servicio de negociación de deuda administrado por el Bufete de abogados. Usted comprende que el Bufete de Abogadoos no es una compania que Aconseja sobre credito o Consolidacion de deuda y no estara haciendo mensualidades a sus acreedores- ¿Es eso su comprensión?', 7)
	 
	  Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('Payments will be made at your direction as funds are available from deposits which you make, and then only at the time a settlement is reached as the result of a successful negotiation – is that your understanding?', 'Los pagos serán hechos en su dirección como fondos estan disponibles de sus depósitos en cuál usted hace, y sólo en aquel momento un arreglo es alcanzado como el resultado de una negociación exitosa - ¿Es eso su comprensión?', 8)
	 
	 Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('During your engagement with the Law Firm, Creditors can add late fees, penalties and interest to the amount of your current balance – is that your understanding?', 'Durante su compromiso con el Bufete de abogados, los Acreedores pueden agregar pagos por tardanza, penalidades y intereses de la cantidad de su balance actual - ¿Es eso su comprensión?', 9)
	
	 Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('You will not be making regular payments to your creditors and that may have an adverse affect on your credit rating as reported by the three major credit bureaus – is that your understanding?', 'Usted no estará haciendo pagos regulares a sus acreedores y que puede tener un adverso efecto negativo sobre su clasificación de crédito como reportado por las tres oficinas mayores de crédito - ¿Es eso su comprensión?', 10)
	
	 Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('Creditors may decide not to negotiate and that one or all of your creditors may seek payment in court, by arbitration, suits, and other legal remedies – is that your understanding?  ', 'Acreedores pueden decidir a no negociar y un o todos su acreedores puede buscar pago en el tribunal, por arbitraje, por las demandas, y por otros medios legales - ¿Es eso su comprensión?', 11)
	
	 Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('This agreement is not for representation of you in a lawsuit and if a lawsuit does arise an additional agreement may need to be signed for representation – is that your understanding?', 'Este acuerdo no es para la representación de usted en una demanda y en que si una demanda surge un acuerdo adicional puede ser necesitado y ser firmado para la representación- ¿Es eso su comprensión?', 12)
	
	 Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('We also need to confirm that you are aware that this is not a loan of any kind; that the Law Firm does not loan or advance money; and that all deposits made by you will be deposited into a settlement deposit account in your name for future settlements – is that your understanding?', 'Nosotros también debemos confirmar que usted está enterado que esto no es un préstamo de cualquier tipo o avanzamos dinero y que todos depósitos hechos por usted será depositados en una Cuenta de Depósito de Liquidacion en su nombre para futuros arreglos- ¿Es eso su comprensión?',13)
	
	 Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('The money held for you in your settlement deposit account is yours and that you may request it at any time – is that your understanding?', 'El dinero detenido para usted en su Cuenta de Depósito de Liquidacion es suyo y que usted puede solicitar en cualquier momento-  ¿Es eso su comprensión?	', 14)
	
	  Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('Any estimates or approximations you have been given about length of time or costs to complete this representation are only estimates and approximations, and your actual completion date may vary depending on settlement amounts and the amount and consistency of your deposits – is that your understanding? ','Cualquier estimación o aproximaciones que han sido dadas acerca del plazo de tiempo o costo de completar esta representación son sólo estimaciones y aproximaciones, y su fecha de terminación verdadera puede variar dependiendo de la cantidad de arreglo y de la cantidad de sus depositos y consistencia de depositos- ¿Es eso su comprensión?', 15)
	
	 Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('In the event that a favorable settlement is reached with the respect to a referred account, your creditor may choose to issue you a form 1099C, and depending on your situation, federal or state law may require you to report part or all of the cancelled debt/savings as unearned income – is that your understanding?','En caso de que un arreglo favorable sea alcanzado con respeto a una cuenta referida su acreedor puede escoger publicar una forma 1099c, y dependiendo de su situación, federal o la ley del estado le puede requerir  reportar parte o toda la deuda cancelada como ingresos no ganados- ¿Es eso su comprensión?', 16)
	
	  Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('The Law Firm does not negotiate settlement of any debts secured by assets including but not limited to autos, homes, recreational vehicles, or personal property – is that your understanding?', 'El Bufete de Abogados no negocia arreglos de ninguna deuda asegurada por ventajas inclusive pero no limitados a autos, casas, a vehículos de recreasion, ni propiedad personal- ¿Es eso su comprensión?  ', 17)
	
	 Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('Also, the Law Firm does not negotiate settlement of any debts for incorporated businesses, military debts, or government backed debts – is that your understanding?', 'Tambien, El Bufete de Abogados no negocia arreglos de ninguna deuda de negocios integrados, deudas militares, ni deudas apoyadas por el gobierno- ¿Es eso su comprensión?', 18)
	
	Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('Can you confirm for us that all of the debts you have included in our service are unsecured debts – is that correct?', 'Puede confirmar con nosotros que todas las deudas que usted ha incluido en nuestros servicios son deudas que no son aseguradas -  ¿Correcto?', 19)
	
	Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('Because we do not handle the type of debts I have just described, any impermissible debt will be removed from your account – is that your understanding?', 'Porque nosotros no manejamos el tipo de deudas que he descrito, qualquier deuda impermisable será quitada de su cuenta-  ¿Es eso su comprensión? ', 20)
	
	Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('Your initial deposit amount of {firstdraftamount} is scheduled to draft on {firstdraftdate}. You have represented to the Law Firm that the bank account you have instructed to draft from is your sole personal account, your business account, a joint personal account on which you are an authorized signer, or an account that you have received authorization from the owner to use for this purpose – is that correct?', 'Su cantidad inicial del depósito de {firstdraftamount} es planificada para redactar en el {firstdraftdate}. Usted a representado al Bufete de Abogados que la cuenta de banco que nos ha instruido para redactar de es su única cuenta personal, su cuenta de negocio, una cuenta conjunta personal en que usted es un firmante autorizado, o una cuenta que usted ha recibido autorización del propietario para utilizar para este proposito, correcto?', 21)
	
	Insert Into tblVerificationQuestion(QuestionTextEN, QuestionTextSP,[Order])
	 Values ('Finally, we need to confirm that you understand and have considered all of the items we have just gone over and that you have decided that you want to be represented by the {lawfirm}– is that correct?', 'Por último, nosotros debemos confirmar que usted comprende y ha considerado todos los artículos sobre que acabamos de revisar y que usted quiere ser representado por el {lawfirm}-correcto?', 22)

		
	Delete From tblVerificationQuestion Where VersionId = 2	
	--1	
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'Can you confirm that you have read the legal service agreement between you and the Attorney?', 'Usted puede confirmar que ha leído el acuerdo legal de servicio entre usted  y el Abogado?', 1)
	 --2
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'The legal service agreement is for the Attorney to represent you in certain claims made by your creditors and also to attempt to negotiate a settlement of some of those claims – is that your understanding?', 'El acuerdo legal de servicio es para que el Abogado lo represente a usted en ciertas reclamaciones hechas por sus acreedores y también para intentar negociar un arreglo de esos reclamos. Es esto de su comprensión?', 2)
	 --3
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'The legal service agreement is also for the Attorney to provide you with other legal services regarding your debts for a fixed fee per month – is that your understanding?', 'El acuerdo de servicio legal es también para que el Abogado le provea a usted de otros servicios legales relacionados a sus deudas por una tarifa fija mensual. Es esto de su comprensión?', 3)
	 --4
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'The legal services being provided for the fixed monthly fee include both non-litigation services and certain litigation related services – is that your understanding?', 'Los servicios legales que se proveen por una tarifa fija mensual incluyen tanto servicios no relacionados con litigios así como ciertos servicios relacionados con litigios. Es esto de su comprensión?', 4)
	 --5
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'The Attorney is a {state} based firm and is not licensed to practice law in other states except when their laws allow it to do so – is that your understanding?', 'El  Abogado es una firma radicada en {state} y no tiene licencia para practicar leyes en otros estados o no ser que las leyes de los mismos lo permita. Es esto de su comprensión?', 5)
	 --6
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'The Attorney has affiliated attorneys in your state who are available for consultation with you – is that your understanding?', 'El Abogado tiene abogados afiliados en su estado, los cuales están disponibles para consulta con usted. Es esto de su comprensión?', 6)
	 --7
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'The outcome of settlements on your accounts cannot be guaranteed and that any settlement is the result of unpredictable negotiation – is that your understanding?', 'El resultado de los arreglos de sus cuentas no puede ser garantizado y que cualquier arreglo es como resultado de una negociación imprevisible.  Es esto de su comprensión?', 7)
	 --8
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'Although we can give you an estimate, no guarantees of any kind can be made of any specific result – is that your understanding?', 'Aunque podamos darle un estimado, ninguna  garantía de cualquier tipo puede ser hecha para obtener un resultado específico. Es esto de su comprensión?', 8)
	 --9
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'We also want to confirm that you are aware that one of the things you are doing is entering a debt negotiation process administered by the Attorney. Do you understand that the Attorney is not a Credit Counseling Company or Debt Consolidator, and that it will not be making monthly payments to your creditors?', 'Nosotros queremos confirmar que es de su conocimiento que usted entra en un proceso de negociación de dueda administrado por el Abogado. Usted entiende que el Abogado no es una Compañía de Consultoría sobre Crédito ni de Consolidación de Deuda, y por tanto,  ésta no enviará pagos mensuales a sus acreedores?', 9)
	 --10
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'If a settlement is reached as to any of your debts, payments will be made at your direction as funds are available from deposits which you make, and then only at the time a settlement is reached as the result of a successful negotiation – is that your  understanding?', 'En caso de que se alcance un arreglo en cualquiera de sus cuentas de dueda, los pagos se harán bajo su consentimiento  mientras haya fondos disponibles de los depósitos que usted hace, y solo en el momento en que un arreglo se logra como resultado de una negociación exitosa. Es esto de su comprensión?', 10)
	 --11
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'During your engagement with the Attorney, Creditors can add late fees, penalties and interest to the amount of your current balance – is that your understanding?', 'Mientas usted está bajo la representación de el Abogado, los acreedores pueden agregar cargos por concepto de atrasos, penalidades e intereses a la cantidad actual del balance de su cuenta. Es esto de su comprensión?', 11)
	 --12
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'If you do not make regular payments to your creditors, that may have an adverse affect on your credit rating as reported by the three major credit bureaus – is that your understanding?', 'Usted no estará haciendo pagos regulares a sus acreedores, y esto puede tener un efecto negativo en su puntaje de crédito reportado por las tres Oficinas Mayores de Crédito. Es esto de su comprensión?', 12)
	 --13
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'Creditors may decide not to negotiate and that one or all of your creditors may seek payment in court, by arbitration, suits, and other legal remedies – is that your understanding?', 'Los acreedores pueden decidir no negociar y tratar de obtener sus pagos en el tribunal a través de arbitraje, demandas u otras vías legales.  Es esto de su comprensión?', 13)
	 --14
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'This agreement is not for representation of you in a lawsuit and if a lawsuit does arise an additional agreement may need to be signed for representation – is that your understanding?', 'Este acuerdo no es para representarlo a usted en caso de una demanda legal, la cual en caso de que surja, se require que un acuerdo addicional de representación sea firmado por usted.  Es esto de su comprensión?', 14)
	 --15
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2,'We also need to confirm that you are aware that this is not a loan of any kind; that the Attorney does not loan or advance money; and that all deposits made by you will be deposited into a client deposit account in your name for future settlements and legal fees – is that your understanding?', 'También necesitamos que usted confirme que sabe que esto no es un préstamo de ningún tipo, que el Abogado no presta ni da dinero por adelantado; y que todos los depósitos hechos por usted serán depositados en una Cuenta de Depósito del Cliente a su nombre para su uso futuro en arreglos y honorarios. Es esto de su comprensión?', 15)
	 --16
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'The money in your client deposit account is yours and that you may request to withdraw it at any time, and you are entitled to your money on deposit except for any amount you then owe to the Attorney – is that your understanding?', 'El dinero en su cuenta de depósito de cliente es suyo y usted puede solicitar retirarlo en cualquier momento. Usted tiene derecho a su dinero en depósito exceptuando cualquier cantidad que usted deba en ese momento al Abogado. Es esto de su comprensión?', 16)
	 --17
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'Any estimates or approximations you have been given about length of time or costs to complete this representation are only estimates and approximations, and may vary depending on many unknown factors, including settlement amounts and the amount and consistency of your deposits – is that your understanding?', 'Todas las estimaciones o aproximaciones que se le hayan dado acerca de tiempo de duración o costos para completar ésta representación son sólo estimados o aproximados, y pueden variar en dependencia de muchos factores desconocidos, incluyendo los montos de los arreglos y la cantidad, regularidad y consistencia de sus depósitos.   Es esto de su comprensión? ', 17)
	 --18
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'In the event that a favorable settlement is reached with the respect to any one of your accounts, your creditor may choose to issue you a form 1099C, and depending on your situation, federal or state law may require you to report part or all of the cancelled debt/savings as unearned income – is that your understanding?', 'En el caso de que un arreglo favorable sea alcanzado con respecto a una de sus cuentas, su acreedor puede elegir emitir una forma 1099C, y dependiendo de su situación, la ley federal o estatal pudiera requerir que usted reporte parte o toda su deuda cancelada o ahorros como ingresos no ganados.  Es esto de su comprensión?', 18)
	 --19
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'The Attorney does not negotiate settlement of any debts secured by assets including but not limited to autos, homes, recreational vehicles, or personal property – is that your understanding?', 'El Abogado no negocia arreglos de deudas aseguradas por bienes incluyendo pero no limitado a: autos, casas, vehículos de recreación, o propiedad personal. Es esto de su comprensión?', 19)
	 --20
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'Also, the Attorney does not negotiate settlement of any debts for incorporated businesses, military debts, or government backed debts – is that your understanding?', 'Además, el Abogado no negocia arreglos de duedas por negocios corporativos, deudas militares, o deudas respaldadas por el gobierno.  Es esto de su comprensión?', 20)
	 --21
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'Can you confirm for us that all of the debts you have included in our service are unsecured debts – is that correct?', 'Puede usted confirmarnos que todas las deudas que ha incluído en nuestro servicio son deudas no aseguradas? ', 21)
	 --22
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'Because we do not handle the type of debts I have just described, any impermissible debt will be removed from your account – is that your understanding?', 'Dado que nosotros no trabajamos con deudas como las que le he acabado de describir, cualquier deuda no permitida será removida de su caso.   Es esto de su comprensión?', 22)
	 --23
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'Your initial deposit amount of {firstdraftamount} is scheduled to draft on {firstdraftdate}. You have represented to the Attorney that the bank account you have instructed to draft from is your sole personal account, your business account, a joint personal account on which you are an authorized signer, or an account that you have received authorization from the owner to use for this purpose – is that correct?', 'Su depósito inicial por la cantidad de {firstdraftamount} está planificado para ser efectuado el  {firstdraftdate}. Usted ha manisfestado al Abogado que la cuenta bancaria que ha proporcionado e instruído para deducir fondos es su cuenta personal, su cuenta de negocios, o cuenta conjunta personal , de la cual es  firmante autorizado, o una cuenta de la cual ha recibido autorización por parte de su propietario para ser usada con este propósito. Es correcto?', 23)
	 --24
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (2, 'Finally, we need to confirm that you understand and have considered all of the items we have just gone over and that you have decided that you want to be represented by {lawfirm}– is that correct?', 'Por último, necesitamos que usted confirme que comprende y ha considerado todos los artículos que hemos acabado de revisar y que ha decidido que quiere ser representado por {lawfirm}. Es correcto?', 24)
	 
	
	Delete From tblVerificationQuestion Where VersionId = 3	
	--1	
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'Can you confirm that you have read the legal service agreement between you and the Attorney?', 'Usted puede confirmar que ha leído el acuerdo legal de servicio entre usted  y el Abogado?', 1)
	 --2
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'The legal service agreement is for the Attorney to represent you in certain claims made by your creditors and also to attempt to negotiate a settlement of some of those claims – is that your understanding?', 'El acuerdo legal de servicio es para que el Abogado lo represente a usted en ciertas reclamaciones hechas por sus acreedores y también para intentar negociar un arreglo de esos reclamos. Es esto de su comprensión?', 2)
	 --3
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'The legal service agreement is also for the Attorney to provide you with other legal services regarding your debts for a fixed fee per month – is that your understanding?', 'El acuerdo de servicio legal es también para que el Abogado le provea a usted de otros servicios legales relacionados a sus deudas por una tarifa fija mensual. Es esto de su comprensión?', 3)
	 --4
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'The legal services being provided for the fixed monthly fee include both non-litigation services and certain litigation related services – is that your understanding?', 'Los servicios legales que se proveen por una tarifa fija mensual incluyen tanto servicios no relacionados con litigios así como ciertos servicios relacionados con litigios. Es esto de su comprensión?', 4)
	 --5
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'The Attorney is a {state} based firm and is not licensed to practice law in other states except when their laws allow it to do so – is that your understanding?', 'El  Abogado es una firma radicada en {state} y no tiene licencia para practicar leyes en otros estados o no ser que las leyes de los mismos lo permita. Es esto de su comprensión?', 5)
	 --6
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'The Attorney has affiliated attorneys in your state who are available for consultation with you – is that your understanding?', 'El Abogado tiene abogados afiliados en su estado, los cuales están disponibles para consulta con usted. Es esto de su comprensión?', 6)
	 --7
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'The outcome of settlements on your accounts cannot be guaranteed and that any settlement is the result of unpredictable negotiation – is that your understanding?', 'El resultado de los arreglos de sus cuentas no puede ser garantizado y que cualquier arreglo es como resultado de una negociación imprevisible.  Es esto de su comprensión?', 7)
	 --8
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'Although we can give you an estimate, no guarantees of any kind can be made of any specific result – is that your understanding?', 'Aunque podamos darle un estimado, ninguna  garantía de cualquier tipo puede ser hecha para obtener un resultado específico. Es esto de su comprensión?', 8)
	 --9
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'We also want to confirm that you are aware that one of the things you are doing is entering a debt negotiation process administered by the Attorney. Do you understand that the Attorney is not a Credit Counseling Company or Debt Consolidator, and that it will not be making monthly payments to your creditors?', 'Nosotros queremos confirmar que es de su conocimiento que usted entra en un proceso de negociación de dueda administrado por el Abogado. Usted entiende que el Abogado no es una Compañía de Consultoría sobre Crédito ni de Consolidación de Deuda, y por tanto,  ésta no enviará pagos mensuales a sus acreedores?', 9)
	 --10
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'If a settlement is reached as to any of your debts, payments will be made at your direction as funds are available from deposits which you make, and then only at the time a settlement is reached as the result of a successful negotiation – is that your  understanding?', 'En caso de que se alcance un arreglo en cualquiera de sus cuentas de dueda, los pagos se harán bajo su consentimiento  mientras haya fondos disponibles de los depósitos que usted hace, y solo en el momento en que un arreglo se logra como resultado de una negociación exitosa. Es esto de su comprensión?', 10)
	 --11
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'During your engagement with the Attorney, Creditors can add late fees, penalties and interest to the amount of your current balance – is that your understanding?', 'Mientas usted está bajo la representación de el Abogado, los acreedores pueden agregar cargos por concepto de atrasos, penalidades e intereses a la cantidad actual del balance de su cuenta. Es esto de su comprensión?', 11)
	 --12
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'If you do not make regular payments to your creditors, that may have an adverse affect on your credit rating as reported by the three major credit bureaus – is that your understanding?', 'Usted no estará haciendo pagos regulares a sus acreedores, y esto puede tener un efecto negativo en su puntaje de crédito reportado por las tres Oficinas Mayores de Crédito. Es esto de su comprensión?', 12)
	 --13
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'Creditors may decide not to negotiate and that one or all of your creditors may seek payment in court, by arbitration, suits, and other legal remedies – is that your understanding?', 'Los acreedores pueden decidir no negociar y tratar de obtener sus pagos en el tribunal a través de arbitraje, demandas u otras vías legales.  Es esto de su comprensión?', 13)
	 --14
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'This agreement is not for representation of you in a lawsuit and if a lawsuit does arise an additional agreement may need to be signed for representation – is that your understanding?', 'Este acuerdo no es para representarlo a usted en caso de una demanda legal, la cual en caso de que surja, se require que un acuerdo addicional de representación sea firmado por usted.  Es esto de su comprensión?', 14)
	 --15
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3,'We also need to confirm that you are aware that this is not a loan of any kind; that the Attorney does not loan or advance money; and that all deposits made by you will be deposited into a client deposit account in your name for future settlements and legal fees – is that your understanding?', 'También necesitamos que usted confirme que sabe que esto no es un préstamo de ningún tipo, que el Abogado no presta ni da dinero por adelantado; y que todos los depósitos hechos por usted serán depositados en una Cuenta de Depósito del Cliente a su nombre para su uso futuro en arreglos y honorarios. Es esto de su comprensión?', 15)
	 --16
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'The money in your client deposit account is yours and that you may request to withdraw it at any time, and you are entitled to your money on deposit except for any amount you then owe to the Attorney – is that your understanding?', 'El dinero en su cuenta de depósito de cliente es suyo y usted puede solicitar retirarlo en cualquier momento. Usted tiene derecho a su dinero en depósito exceptuando cualquier cantidad que usted deba en ese momento al Abogado. Es esto de su comprensión?', 16)
	 --17
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'Any estimates or approximations you have been given about length of time or costs to complete this representation are only estimates and approximations, and may vary depending on many unknown factors, including settlement amounts and the amount and consistency of your deposits – is that your understanding?', 'Todas las estimaciones o aproximaciones que se le hayan dado acerca de tiempo de duración o costos para completar ésta representación son sólo estimados o aproximados, y pueden variar en dependencia de muchos factores desconocidos, incluyendo los montos de los arreglos y la cantidad, regularidad y consistencia de sus depósitos.   Es esto de su comprensión? ', 17)
	 --18
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'In the event that a favorable settlement is reached with the respect to any one of your accounts, your creditor may choose to issue you a form 1099C, and depending on your situation, federal or state law may require you to report part or all of the cancelled debt/savings as unearned income – is that your understanding?', 'En el caso de que un arreglo favorable sea alcanzado con respecto a una de sus cuentas, su acreedor puede elegir emitir una forma 1099C, y dependiendo de su situación, la ley federal o estatal pudiera requerir que usted reporte parte o toda su deuda cancelada o ahorros como ingresos no ganados.  Es esto de su comprensión?', 18)
	 --19
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'The Attorney does not negotiate settlement of any debts secured by assets including but not limited to autos, homes, recreational vehicles, or personal property – is that your understanding?', 'El Abogado no negocia arreglos de deudas aseguradas por bienes incluyendo pero no limitado a: autos, casas, vehículos de recreación, o propiedad personal. Es esto de su comprensión?', 19)
	 --20
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'Also, the Attorney does not negotiate settlement of any debts for incorporated businesses, military debts, or government backed debts – is that your understanding?', 'Además, el Abogado no negocia arreglos de duedas por negocios corporativos, deudas militares, o deudas respaldadas por el gobierno.  Es esto de su comprensión?', 20)
	 --21
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'Can you confirm for us that all of the debts you have included in our service are unsecured debts – is that correct?', 'Puede usted confirmarnos que todas las deudas que ha incluído en nuestro servicio son deudas no aseguradas? ', 21)
	 --22
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'Because we do not handle the type of debts I have just described, any impermissible debt will be removed from your account – is that your understanding?', 'Dado que nosotros no trabajamos con deudas como las que le he acabado de describir, cualquier deuda no permitida será removida de su caso.   Es esto de su comprensión?', 22)
	 --23
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'Your initial deposit amount of {firstdraftamount} is scheduled to draft on {firstdraftdate}. You have represented to the Attorney that the bank account you have instructed to draft from is your sole personal account, your business account, a joint personal account on which you are an authorized signer, or an account that you have received authorization from the owner to use for this purpose – is that correct?', 'Su depósito inicial por la cantidad de {firstdraftamount} está planificado para ser efectuado el  {firstdraftdate}. Usted ha manisfestado al Abogado que la cuenta bancaria que ha proporcionado e instruído para deducir fondos es su cuenta personal, su cuenta de negocios, o cuenta conjunta personal , de la cual es  firmante autorizado, o una cuenta de la cual ha recibido autorización por parte de su propietario para ser usada con este propósito. Es correcto?', 23)
	 --24
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 'We need to confirm that you understand and have considered all of the items we have just gone over and that you have decided that you want to be represented by {lawfirm}– is that correct?', 'Necesitamos que usted confirme que comprende y ha considerado todos los artículos que hemos acabado de revisar y que ha decidido que quiere ser representado por {lawfirm}. Es correcto?', 24)
	 --25
	 Insert Into tblVerificationQuestion(VersionId, FailWhenNo, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 0, 'We also want you to know that if you owe money to your bank, it is possible that your bank could seize money from your account to pay what it is owed, without notice to you.  Do you understand that risk?', 'Deseamos también que sepa que si debe dinero a su banco, es posible que su banco pueda agarrar dinero de su cuenta para pagar lo que es debido, sin nota a usted. ¿Comprende ese riesgo?', 25)
	 --26
	 Insert Into tblVerificationQuestion(VersionId, FailWhenNo, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 0, 'We also want you to know that if you have any other debts, either secured or unsecured, at the same institution as debts you have listed with the attorney, the creditor may be able to divert the payments made to the other accounts to the delinquent account.  Do you understand that risk?', 'Deseamos también que sepa que si tiene cualquier otras deudas, asegurado o no garantizado, en la misma institución como deudas que usted ha listado con el abogado, el acreedor puede poder desviar los pagos hechos a las otras cuentas a la cuenta morosa. ¿Comprende ese riesgo?', 26)
	 --27 
	 Insert Into tblVerificationQuestion(VersionId, FailWhenNo, QuestionTextEN, QuestionTextSP, [Order])
	 Values (3, 0, 'Finally, we want you to know that if you do not pay for utility services, the utility might stop providing services to you. Do you understand that risk?', 'Por último, deseamos que sepa que si usted no paga por servicios versátiles, la utilidad quizás pare servicios que proporciona a usted. ¿Comprende ese riesgo?', 27)
	 
	 */
	 
	 
	Delete From tblVerificationQuestion Where VersionId = 4	
	--1	
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, '{title} {clientfullname} You will be hiring The Law firm to perform 2 separate and independent services. The first contracted services, detailed in Section B1 of your Legal Services Agreement, are non-litigation legal services completed at the time of enrollment. You have agreed to pay a fee of {initialservicefees} for these Initial Services. The fee is included in your deposit estimate of {monthlyamount} dollars per month and may be paid using funds from your first monthly deposits. Do you understand and agree?', '{title} {clientfullname} Usted estará contratando la firma de abogados para llevar a cabo dos servicios separados e independientes. Los servicios iniciales, que se detallan en la sección B1 de su Contrato de Servicios Legales, son completados al inicio del programa y no son servicios de litigación. Usted ha acordado pagar una cuota de {initialservicefees} por estos servicios iniciales. La cuota se incluye en su término estimado y será pagada de sus fondos en acumulación. ¿Usted entiende y acepta?', 1)
	 --2
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'At this time, you will be simultaneously and separately hiring the law firm to perform debt settlement services, as outlined in section B3 of your Legal Services Agreement. You have sought debt settlement services because you feel you cannot and will not be able to continue making payments to your creditors. Is this correct?', 'En este momento, usted estará simultáneamente y por separado contratando a la firma de abogados para brindar servicios de liquidación de deudas, según se describe en la sección B3 de su Contrato de Servicios Legales. Usted ha buscado los servicios de liquidación de deudas porque siente que no puede y no será capaz de seguir haciendo los pagos a sus acreedores. ¿Entiende y esta de acuerdo?', 2)
	 --3
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'Due to many factors beyond its control, The Law Firm cannot guarantee the amount of time it will take to completely resolve all of Referred Accounts. Do you understand and agree?', 'Debido a muchos factores fuera de nuestro control la Firma no puede garantizar el tiempo necesario para resolver sus cuentas referidas. Entiende usted y esta de acuerdo?', 3)
	 --4
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'During this process The Law Firm will not make monthly payments to your creditors. As a result, interest and penalties may accrue. As sufficient funds accumulate in your Settlement Deposit Account, equal to 10% of your outstanding balance, the Law Firm will negotiate with your creditors. Payment will only be made to your creditors once a settlement has been reached. Do you understand and agree?', 'Durante este proceso, la firma de abogados no realizará pagos mensuales a sus acreedores. Como resultado de ello, los intereses y los recargos pueden acumularse.  A medida que los fondos se acumulan en su Cuenta de Depósitos y cuando haya un equivalente al 10% de su saldo pendiente, el bufete de abogados negociara con sus acreedores. El pago sólo se hará a sus acreedores una vez se haya llegado a un acuerdo. ¿Usted entiende y acepta?', 4)
	 --5
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'During this process your creditors may report negative information to the credit bureaus which will show on your credit report. Do you understand and agree?', 'Durante el proceso sus acreedores pueden reportar marcas negativas a los bureos de crédito, cual se reflejaran en su reporte de crédito. Entiende usted y está de acuerdo?', 5)
	 --6
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'Your deposit of {firstdraftamount} includes a monthly service fee of {maintenancefee} as described in section E 3(a) of your Legal Services Agreement. This amount will be drafted by the law firm from your bank account on {firstdraftdate}. Thereafter the law firm will draft {monthlyamount} on the {depositday} of each month until our service is complete. Do you understand and agree?', 'Su depósito de {firstdraftamount} incluye una tarifa mensual de {maintenancefee} como escrito en la sección E sub-seccion 3(a) de su Contrato de Servicios Legales y será retirado por el Bufete de su cuenta bancaria el {firstdraftdate}. A partir de entonces, el Bufete retirara {monthlyamount} el {depositday} de cada mes hasta que se completen nuestros servicios. Entiende usted y está de acuerdo?', 6)
	 --7
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'For the purposes of making your monthly deposits, you have authorized drafts from a checking account number {bankaccountnumber} located at {bankname}. Do you acknowledge that this information is correct and that this account belongs to you or is under your personal legal control?', 'Para el proposito de hacer sus depositos mensuales, usted esta autorizando retirar la mensualidad de su cuenta bancaria numero {bankaccountnumber} ubicado en el {bankname}. Reconoce que esta informacion es correcta y que esta cuenta le pertenece o esta bajo su control legal personal?', 7)
	 --8
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'These funds, once drafted, will be held in Trust. These funds will be maintained for the purpose of future settlements and fee earned by the law firm. All funds in this account, including fees not yet earned, belong to you and may be withdrawn at anytime.   Do you understand and agree?', 'Estos fondos una vez tomados seran depositados en una cuenta de fideicomiso. Estos fondos se mantendran y seran usados para el proposito de saldar sus cuentas y para pagar los honorarios de la Firma. Los fondos en esta cuenta que no hayan sido utilizados para saldar sus cuentas referidas pertenecen al cliente y podran ser retirados por el cliente en cualquier momento. Estiende usted y esta de acuerdo?', 8)
	 --9
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'As compensation for debt settlement services, you have agreed to pay The Law Firm a fee equivalent to {settlementpercentfee} of the verified original balance of each account at the time of enrollment. This fee is due at time of settlement of each debt. You are giving the Law Firm authority to ONLY withdraw Law Firms fee when due. Do you understand and agree?', 'Como compensación por los servicios de liquidación de la deuda, usted ha acordado pagar al bufete de abogados una cuota equivalente al {settlementpercentfee} del saldo original verificado de cada cuenta en el momento de que fue ingresada. Esta compensación de ahorro es debida al tiempo que se llega a un acuerdo de negociación. Usted le está dando autorización al Bufete de Abogados para retirar esta comisión SOLO cuando sea debida. Entiende usted y está de acuerdo?',9)
	 --10
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'While enrolled in debt settlement services, should you decide to add or remove accounts; your monthly deposit amount and the length of your service term will be subject to change. Do you understand and agree?', 'Mientras esté inscrito en los servicios de pago de la deuda, si usted decide agregar o quitar cuentas, la cantidad de su depósito mensual y la duración de su programa estará sujeto a cambios. ¿Usted entiende y acepta?', 10)
	 --11
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'You are giving the Law Firm the authority to accept any settlement offer equal to or less than 55% of the outstanding balance of the account at the time of that offer.  Do you understand and agree?', 'Usted está dando a la Firma la autoridad de aceptar cualquier oferta de liquidación igual o inferior al 55% del saldo de la cuenta en el momento de la oferta. ¿Usted entiende y acepta?', 11)
	 --12
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'You have informed us that all of your debt is unsecured. If any of your debt is secured, it may be subject to repossession by the creditor. Do you understand and agree?', 'Usted nos ha informado que toda su deuda no es asegurada. Si cualquiera de su deuda es asegurada, puede ser sujeto a reposición por el acreedor. Entiende usted y está de acuerdo?', 12)
	 --13
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4,'If there are credit cards or other unsecured debts that you are not enrolling in our service, but are making payments on. It could severely limit or even negate our ability reach a settlement with your creditors. Do you understand and agree?', 'Si hay tarjetas de crédito u otra deuda no asegurada cual usted no está incluyendo en nuestro servicio, pero aun continúa pagando; esto podría limitar o negar severamente nuestra habilidad de llegar a un acuerdo con sus acreedores. Entiende usted y está de acuerdo?', 13)
	 --14
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'Are you a business owner? If yes {newline} a.	Are any of these debts tied to your business?', 'Es usted dueño de algún negocio? Si asi lo es………{newline} a. Cualquiera de sus deudas forman parte de su negocio?', 14)
	 --15
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'For your protection, and for quality assurance purposes, all inbound and outbound calls between The Law Firm and Client may be recorded. Do you understand and agree?', 'Para su protección y para propósitos de aseguramiento de calidad, todas las llamadas entrantes y salientes entre la firma de abogados y el cliente pueden ser grabadas.  Entiende usted y está de acuerdo?', 15)
	 --16
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'During your enrollment consultation, the Law Firm’s services were explained fully and in sufficient detail so as to enable you to make an educated decision to retain said services at this time. Do you confirm that you understand these services at this time?', 'Durante su consulta de inscripcion la Firma le explico por completo y en detalle nuestros servicios permitiendole tomar una decision razonable e informada de nuestros servicios en ese momento. Puede confirmar que usted entendio nuestros servicios cuando le fueron explicados?', 16)
	 --17
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'Do you confirm that your decision to engage the Law Firm’s Services was made  after complete and careful consideration of your individual circumstances and that you have chosen this course of action to resolve the Referred Accounts independent of any  marketing efforts,  Advertisements,   promotional materials or undue influence of any kind?', 'Puede confirmar que usted tomo la decision de contratar al Bufete de Abogados despues de haber considerado en detalle y cuidadosamente su condicion y circunstancias personales y que usted escogio este curso de accion para resolver sus cuentas referidas independientemente de cualquier comercial o material de promocion o de cualquier influencia indebida o presion de cualquier tipo.', 17)
	 --18
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'To the extent that a favorable settlement may be reached with respect to a Referred Account, federal and/or state law may require you to treat the amount of cancelled debt as income for purposes of federal and/or state taxes. In some instances your creditors may report any savings above $600.00 to the IRS? As a result, you may be issued a 1099 from your creditors Law Firm makes no representations regarding the taxability of the amount of cancelled debt and recommends that you consult a tax professional regarding your specific situation. Do you understand and agree?','A medida que lleguemos a un acuerdo de negociación favorable en respecto a una Cuenta Referida, la ley federal y/o estatal podría requerir que usted trate el monto de su deuda cancelada como ingresos para propósitos de impuestos federales y/o estatales.  En ciertas ocasiones sus acreedores pueden reportar ahorros de más de $600 al IRS.  Como resultado, es posible que usted reciba la forma 1099 de parte de sus acreedores. El Bufete de Abogados no hace ninguna representación en respecto a impuestos sobre la cantidad de deuda cancelada y le recomienda que consulte con un profesional de impuestos en lo que respecta a su situación en lo especial. Entiende usted y está de acuerdo?', 18)
	 --19
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'In accordance with your legal services agreement, you have been provided with the opportunity to inquire about additional legal services including Bankruptcy.  Once you have retained the Law Firm you may inquire about additional legal services including bankruptcy at any time.  Do you understand and agree?','De acuerdo a su contrato de servicios legales usted ha sido informado de la oportunidad de consultar a la Firma de cualquier otro servicio legal incluyendo bancarrota.', 19)
	 --20
	 Insert Into tblVerificationQuestion(VersionId, QuestionTextEN, QuestionTextSP, [Order])
	 Values (4, 'Everything we discussed today is outlined in detail in your Legal Services Agreement. Do you acknowledge that you have read, signed, fully understand, and agree with all the terms of your Legal Service Agreement?', 'Todo lo que hemos conversado está escrito en detalle en su Contrato de Servicios Legales. Usted reconoce que ha leído, firmado, y entiende por completo todo los términos de su Contrato de Servicios Legales?', 20)
	

	 GO
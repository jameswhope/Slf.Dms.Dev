 /****** Object:  ForeignKey [FK_tblClientExpenses_tblClientExpenseTypes]    Script Date: 04/13/2009 06:57:37 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblClientExpenses_tblClientExpenseTypes]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblClientExpenses]'))
ALTER TABLE [dbo].[tblClientExpenses]  WITH CHECK ADD  CONSTRAINT [FK_tblClientExpenses_tblClientExpenseTypes] FOREIGN KEY([ClientExpenseTypeID])
REFERENCES [dbo].[tblClientExpenseTypes] ([ExpenseTypeID])
GO
ALTER TABLE [dbo].[tblClientExpenses] CHECK CONSTRAINT [FK_tblClientExpenses_tblClientExpenseTypes]
GO
/****** Object:  ForeignKey [FK_tblClientExpenses_tblClientRelationshipTypes]    Script Date: 04/13/2009 06:57:37 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblClientExpenses_tblClientRelationshipTypes]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblClientExpenses]'))
ALTER TABLE [dbo].[tblClientExpenses]  WITH CHECK ADD  CONSTRAINT [FK_tblClientExpenses_tblClientRelationshipTypes] FOREIGN KEY([ClientRelationTypeID])
REFERENCES [dbo].[tblClientRelationshipTypes] ([ClientRelationshipTypeID])
GO
ALTER TABLE [dbo].[tblClientExpenses] CHECK CONSTRAINT [FK_tblClientExpenses_tblClientRelationshipTypes]
GO
/****** Object:  ForeignKey [FK_tblClientIncome_tblClientIncomeTypes]    Script Date: 04/13/2009 06:57:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblClientIncome_tblClientIncomeTypes]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblClientIncome]'))
ALTER TABLE [dbo].[tblClientIncome]  WITH CHECK ADD  CONSTRAINT [FK_tblClientIncome_tblClientIncomeTypes] FOREIGN KEY([IncomeTypeId])
REFERENCES [dbo].[tblClientIncomeTypes] ([IncomeTypeID])
GO
ALTER TABLE [dbo].[tblClientIncome] CHECK CONSTRAINT [FK_tblClientIncome_tblClientIncomeTypes]
GO
/****** Object:  ForeignKey [FK_tblClientIncome_tblClientRelationshipTypes]    Script Date: 04/13/2009 06:57:42 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblClientIncome_tblClientRelationshipTypes]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblClientIncome]'))
ALTER TABLE [dbo].[tblClientIncome]  WITH CHECK ADD  CONSTRAINT [FK_tblClientIncome_tblClientRelationshipTypes] FOREIGN KEY([ClientRelationTypeID])
REFERENCES [dbo].[tblClientRelationshipTypes] ([ClientRelationshipTypeID])
GO
ALTER TABLE [dbo].[tblClientIncome] CHECK CONSTRAINT [FK_tblClientIncome_tblClientRelationshipTypes]
GO
/****** Object:  ForeignKey [FK_tblClientMedicalHistory_tblClientRelationshipTypes]    Script Date: 04/13/2009 06:57:46 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblClientMedicalHistory_tblClientRelationshipTypes]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblClientMedicalHistory]'))
ALTER TABLE [dbo].[tblClientMedicalHistory]  WITH CHECK ADD  CONSTRAINT [FK_tblClientMedicalHistory_tblClientRelationshipTypes] FOREIGN KEY([ClientRelationTypeID])
REFERENCES [dbo].[tblClientRelationshipTypes] ([ClientRelationshipTypeID])
GO
ALTER TABLE [dbo].[tblClientMedicalHistory] CHECK CONSTRAINT [FK_tblClientMedicalHistory_tblClientRelationshipTypes]
GO
/****** Object:  ForeignKey [FK_tblClientMedicalHistoryConditions_tblClientMedicalConditionTypes]    Script Date: 04/13/2009 06:57:47 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblClientMedicalHistoryConditions_tblClientMedicalConditionTypes]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblClientMedicalHistoryConditions]'))
ALTER TABLE [dbo].[tblClientMedicalHistoryConditions]  WITH CHECK ADD  CONSTRAINT [FK_tblClientMedicalHistoryConditions_tblClientMedicalConditionTypes] FOREIGN KEY([ConditionTypeID])
REFERENCES [dbo].[tblClientMedicalConditionTypes] ([ConditionTypeID])
GO
ALTER TABLE [dbo].[tblClientMedicalHistoryConditions] CHECK CONSTRAINT [FK_tblClientMedicalHistoryConditions_tblClientMedicalConditionTypes]
GO
/****** Object:  ForeignKey [FK_tblClientMedicalHistoryConditions_tblClientMedicalHistory]    Script Date: 04/13/2009 06:57:47 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblClientMedicalHistoryConditions_tblClientMedicalHistory]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblClientMedicalHistoryConditions]'))
ALTER TABLE [dbo].[tblClientMedicalHistoryConditions]  WITH CHECK ADD  CONSTRAINT [FK_tblClientMedicalHistoryConditions_tblClientMedicalHistory] FOREIGN KEY([MedicalHistoryID])
REFERENCES [dbo].[tblClientMedicalHistory] ([MedicalHistoryID])
GO
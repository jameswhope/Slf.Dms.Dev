BEGIN
If NOT EXISTS(Select CommRecGroupId From tblCommRecGroup)

INSERT tblCommRecGroup(CommRecGroupName) VALUES('The Seideman Law Firm')
INSERT tblCommRecGroup(CommRecGroupName) VALUES('The Palmer Firm')
INSERT tblCommRecGroup(CommRecGroupName) VALUES('Lexxiom Inc.')
INSERT tblCommRecGroup(CommRecGroupName) VALUES('Avert Financial LLC')
INSERT tblCommRecGroup(CommRecGroupName) VALUES('Debt Choice')
INSERT tblCommRecGroup(CommRecGroupName) VALUES('Antilla Holdings LLC')
INSERT tblCommRecGroup(CommRecGroupName) VALUES('GNUSAMI	Global Network USA Marketing, Inc.')
INSERT tblCommRecGroup(CommRecGroupName) VALUES('David Potter')
INSERT tblCommRecGroup(CommRecGroupName) VALUES('Jeff Slakter')
INSERT tblCommRecGroup(CommRecGroupName) VALUES('Chris Lauzon')
INSERT tblCommRecGroup(CommRecGroupName) VALUES('Debt Zero, Inc.')
INSERT tblCommRecGroup(CommRecGroupName) VALUES('Smith-Allen, Inc.')
INSERT tblCommRecGroup(CommRecGroupName) VALUES('The Gateway Referral Network, Inc.')

END
GO




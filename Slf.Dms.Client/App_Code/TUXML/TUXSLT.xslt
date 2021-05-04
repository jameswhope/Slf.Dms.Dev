<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:ms="urn:schemas-microsoft-com:xslt"
    xmlns:userfn="urn:my-scripts">
  <ms:script language ="VB" implements-prefix ="userfn">
    <![CDATA[
      public function convertTimeZone(dt as DateTime) as String
        return dt.ToLocalTime.ToString("MM/dd/yy hh:mm:ss tt") & " PT"
      end function
    ]]>
  </ms:script>
  <xsl:output method="xml" indent="yes" />

  <xsl:template match="/creditBureau">
    <div>
      <div class="tuHeader">
        <table>
          <tr>
            <td class="tuLogo">
              <div class="tuLogoImage tuLogoUrl">
                &#160;
              </div>
              <div class="tuLogoText">
                Transunion Consumer Credit Report
              </div>
            </td>
            <td class="subscriberPanel">
              <div>
                <xsl:apply-templates select="transactionControl" />
                <xsl:call-template name="inputParameters" />
              </div>
            </td>
          </tr>
        </table>
      </div>

      <div class="section">
        <xsl:apply-templates select="product/subject/subjectRecord/indicative" />
      </div>

      <xsl:if test ="count(product/subject/subjectRecord/custom/credit/collection)!=0">
        <div class="section">
          <div class="headSection">
            <h2>COLLECTIONS</h2>
          </div>
          <div class="collection">
            <table>
              <xsl:apply-templates select="product/subject/subjectRecord/custom/credit/collection" />
            </table>
          </div>
        </div>
      </xsl:if>

      <xsl:if test ="count(product/subject/subjectRecord/custom/credit/publicRecord)!=0">
        <div class="section">
          <div class="headSection">
            <h2>PUBLIC RECORDS</h2>
          </div>
          <div class="publicRecord">
            <table>
              <xsl:apply-templates select="product/subject/subjectRecord/custom/credit/publicRecord" />
            </table>
          </div>
        </div>
      </xsl:if>

      <xsl:if test ="count(product/subject/subjectRecord/custom/credit/trade)!=0">
        <div class="section">
          <div class="headSection">
            <h2>TRADES</h2>
          </div>
          <div class="trade">
            <table>
              <xsl:apply-templates select="product/subject/subjectRecord/custom/credit/trade" />
            </table>
          </div>
        </div>
      </xsl:if>

      <xsl:if test ="count(product/subject/subjectRecord/custom/credit/inquiry)!=0">
        <div class="section">
          <div class="headSection">
            <h2>INQUIRIES</h2>
          </div>
          <div class="inquiry">
            <table>
              <tr>
                <td>Date</td>
                <td>Subscriber Name (Code)</td>
              </tr>
              <xsl:apply-templates select="product/subject/subjectRecord/custom/credit/inquiry" />
            </table>
          </div>
        </div>
      </xsl:if>

      <div class="section">
        <div class="headSection">
          <h2>CREDITOR CONTACT</h2>
        </div>
        <div class="creditor">
          <xsl:apply-templates select="product/subject/subjectRecord/addOnProduct/creditorContact" />
        </div>
      </div>
      
      <div class="section" style="clear:both;" >
        <div class="headSection">
          <h2>REPORT SERVICED BY</h2>
        </div>
        <div class="service">
          TRANSUNION<br/>
          (800) 888-4213<br/>
          P.O. BOX 1000, CHESTER, PA 19022<br/>
          CONSUMER DISCLOSURES CAN BE OBTAINED ONLINE THROUGH TRANSUNION AT:<br/>
          HTTP://WWW.TRANSUNION.COM
        </div>
      </div>

      <div class="endFooter">
        END OF REPORT
      </div>
    </div>
  </xsl:template>

  <xsl:template match="transactionControl">
    <div>
      <table>
        <tr>
          <td>Subscriber Name:</td>
          <td>
            <xsl:value-of select="//requestParameters/subscriberName"/>
          </td>
        </tr>
        <tr>
          <td>Subscriber Code/Market:</td>
          <td>
            <xsl:value-of select="subscriber/industryCode"/>&#160;
            <xsl:value-of select="subscriber/memberCode"/>&#160;
            <xsl:value-of select="//product/subject/subjectRecord/fileSummary/market"/>&#160;
            <xsl:value-of select="//product/subject/subjectRecord/fileSummary/submarket"/>
          </td>
        </tr>
        <tr>
          <td>
            Results Issued:
          </td>
          <td>
            <xsl:value-of select="userfn:convertTimeZone(tracking/transactionTimeStamp)" /> 
          </td>
        </tr>
      </table>
    </div>
  </xsl:template>

  <xsl:template name ="inputParameters">
    <div>
      <div class="parametersLabel">Input Parameters For Primary Subject</div>
      <table>
        <tr>
          <td>
            Reference ID:
          </td>
          <td>
            <xsl:value-of select="//transactionControl/userRefNumber"/>
          </td>
        </tr>
        <tr>
          <td>SSN:</td>
          <td>
            <xsl:value-of select="concat('XXX-XX-',substring(//requestParameters/subjectSSN,6))" />
          </td>
        </tr>
        <tr>
          <td>
            Name:
          </td>
          <td>
            <xsl:value-of select="//requestParameters/subjectName"/>
          </td>
        </tr>
        <tr>
          <td>
            Current Address:
          </td>
          <td >
            <xsl:value-of select="//requestParameters/subjectStreet"/><br/>
            <xsl:value-of select="//requestParameters/subjectLocation"/>
          </td>
        </tr>
      </table>
    </div>
  </xsl:template>

  <xsl:template match ="product/subject/subjectRecord/indicative">
    <div class="indicativeName">
      <table>
        <tr>
          <td colapn="7">
            <xsl:value-of select="name/person/last"/>,
            <xsl:value-of select="name/person/first"/>&#160;
            <xsl:value-of select="name/person/middle"/>
          </td>
        </tr>
        <tr>
          <td>Also Known As:</td>
          <td>SSN:</td>
          <td>
            <xsl:value-of select="concat('XXX-XX-',substring(socialSecurity/number,6))"/>
          </td>
          <td>Phone:</td>
          <td>
            <xsl:if test ="count(phone/number) != 0">
              (<xsl:value-of select="phone/number/areaCode"/>)-
              <xsl:value-of select="phone/number/exchange"/>-
              <xsl:value-of select="phone/number/suffix"/>
            </xsl:if>
          </td>
          <td>In File Since:</td>
          <td>
            <xsl:value-of select="ms:format-date(//product/subject/subjectRecord/fileSummary/inFileSinceDate,'MM/yy')" />
          </td>
        </tr>
        <tr>
          <td>
            <xsl:apply-templates select ="name/qualifier[text()='alsoKnownAs']" />
          </td>
          <td>Date of Birth:</td>
          <td>
            <xsl:value-of select="ms:format-date(dateOfBirth, 'MM/yy')"/>
          </td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
        </tr>
      </table>
    </div>

    <div class="indicativeAddress">
      <table>
        <tr>
          <td>
            <xsl:apply-templates select="address[1]" />
          </td>
          <td>
            <xsl:apply-templates select="address[2]" />
          </td>
          <td>
            <xsl:apply-templates select="address[3]" />
          </td>
        </tr>
      </table>
    </div>

    <div class="employment">
      <div class="headSection" >
        <h2>EMPLOYMENT</h2>
      </div>
      <div>
        <table>
          <xsl:apply-templates select="employment" />
        </table>
      </div>
    </div>
  </xsl:template>

  <xsl:template match ="name/qualifier[text()='alsoKnownAs']">
    <xsl:value-of select="ancestor::name/person/unparsed"/>
    <br/>
  </xsl:template>

  <xsl:template match="address" >
    <div class="addressStatus">
      <xsl:value-of select="status"/>&#160;Address:
    </div>
    <div class="address">
      <xsl:call-template name ="address"/>
    </div>
    <div class="addressDate">
      <xsl:if test ="count(dateReported) != 0">
        Reported&#160;<xsl:value-of select="ms:format-date(dateReported, 'MM/yy')"/>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template name ="address">
    <xsl:value-of select="street/number"/>&#160;
    <xsl:value-of select="street/predirectional"/>&#160;
    <xsl:value-of select="street/name"/>&#160;
    <xsl:value-of select="street/postdirectional"/>&#160;
    <xsl:value-of select="street/type"/>&#160;
    <xsl:value-of select="street/unit/type"/>&#160;
    <xsl:value-of select="street/unit/number"/><br/>
    <xsl:value-of select="location/city"/>&#160;
    <xsl:value-of select="location/state"/>&#160;
    <xsl:value-of select="location/zipCode"/>
  </xsl:template>

  <xsl:template match="employment">
    <tr class="firstRow">
      <td>
        <xsl:value-of select="employer/unparsed"/>
        <br/>
      </td>
      <td>
        Position:
      </td>
      <td>
        <xsl:value-of select="occupation"/>
      </td>
      <td>
        Start:
      </td>
      <td>
        <xsl:value-of select="ms:format-date(dateHired, 'MM/yy')"/>
      </td>
      <td>In File Since:</td>
      <td>
        <xsl:value-of select="ms:format-date(dateOnFileSince, 'MM/yy')"/>
      </td>
    </tr>
    <tr>
      <td>
      </td>
      <td>
      </td>
      <td>
      </td>
      <td>
        End:
      </td>
      <td>
        <xsl:value-of select="ms:format-date(dateTerminated, 'MM/yy')"/>
      </td>
      <td>
        Effective:
      </td>
      <td>
        <xsl:value-of select="ms:format-date(dateEffective, 'MM/yy')"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template  match ="product/subject/subjectRecord/custom/credit/trade">
    <tr class="firstRow">
      <td colspan="2">
        <xsl:value-of select="subscriber/name/unparsed"/> (<xsl:value-of select="subscriber/industryCode"/>&#160;<xsl:value-of select="subscriber/memberCode"/>)
      </td>
      <td colspan="2">
        Account # <xsl:value-of select="accountNumber"/>
      </td>
      <td colspan="2"></td>
      <td colspan="2">
        Account Rating <xsl:value-of select="accountRating"/>
      </td>
    </tr>
    <tr>
      <td>Type:</td>
      <td>
        <xsl:value-of select="portfolioType"/>
      </td>
      <td>Credit Limit:</td>
      <td>
        <xsl:choose>
          <xsl:when test="string(number(creditLimit))='NaN'"></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(creditLimit, '$###,###,##0')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>Balance:</td>
      <td>
        <xsl:choose>
          <xsl:when test="string(number(currentBalance))='NaN'"></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(currentBalance, '$###,###,##0')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        Opened:
      </td>
      <td>
        <xsl:value-of select="ms:format-date(dateOpened, 'MM/yy')"/>
      </td>
    </tr>
    <tr>
      <td>
        Loan Type:
      </td>
      <td>
        <xsl:apply-templates select="account/type" />
      </td>
      <td>
        High Credit:
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(number(highCredit))='NaN'"></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(highCredit, '$###,###,##0')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        Past Due:
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(number(pastDue))='NaN'"></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(pastDue, '$###,###,##0')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        Paid:
      </td>
      <td>
        <xsl:value-of select="ms:format-date(datePaidOut, 'MM/yy')"/>
      </td>
    </tr>
    <tr>
      <td>
        Responsibility:
      </td>
      <td>
        <xsl:value-of select="ECOADesignator"/>
      </td>
      <td>
        Terms:
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(number(terms/scheduledMonthlyPayment))='NaN'"></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(terms/scheduledMonthlyPayment, '$###,###,##0')"/>
          </xsl:otherwise>
        </xsl:choose>&#160;<xsl:value-of select="terms/paymentFrequency"/>&#160;<xsl:value-of select="terms/paymentScheduleMonthCount"/>
      </td>
      <td>
        Last Payment:
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(number(mostRecentPayment/amount))='NaN'"></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(mostRecentPayment/amount, '$###,###,##0')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        Closed:
      </td>
      <td>
        <xsl:value-of select="ms:format-date(dateClosed, 'MM/yy')"/>
      </td>
    </tr>
    <tr>
      <td>
        Remarks:
      </td>
      <td>
        <xsl:apply-templates select="remark/code" />
      </td>
      <td></td>
      <td></td>
      <td>
        Charge Off:
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(number(additionalTradeAccount/original/chargeOff))='NaN'"></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(additionalTradeAccount/original/chargeOff, '$###,###,##0')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        Verified:
      </td>
      <td>
        <xsl:value-of select="ms:format-date(dateEffective, 'MM/yy')"/>
      </td>
    </tr>
    <tr>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td>Update Method:</td>
      <td>
        <xsl:value-of select="updateMethod"/>
      </td>
    </tr>
    <tr>
      <td rowspan="2" class="latePayments">
        Late Payments<br/>
        <span>
          (<xsl:choose>
            <xsl:when test="string(number(paymentHistory/historicalCounters/monthsReviewedCount))='NaN'"></xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="format-number(paymentHistory/historicalCounters/monthsReviewedCount, '#####0')"/>
            </xsl:otherwise>
          </xsl:choose>&#160;Months)
        </span>
      </td>
      <td rowspan="2">
        <span class="delinquency">Delinquency</span>
        <table class="paymentHistory">
          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="string(number(paymentHistory/historicalCounters/late30DaysTotal))='NaN'">&#160;</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="format-number(paymentHistory/historicalCounters/late30DaysTotal, '#####0')"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="string(number(paymentHistory/historicalCounters/late60DaysTotal))='NaN'">&#160;</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="format-number(paymentHistory/historicalCounters/late60DaysTotal, '#####0')"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="string(number(paymentHistory/historicalCounters/late90DaysTotal))='NaN'">&#160;</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="format-number(paymentHistory/historicalCounters/late90DaysTotal, '#####0')"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr>
            <td>
              <span>30</span>
            </td>
            <td>
              <span>60</span>
            </td>
            <td>
              <span>90</span>
            </td>
          </tr>
        </table>
      </td>
      <td>
        Maximum:
      </td>
      <td></td>
      <td colspan="2" class="paymentPattern">
        Payment Pattern
      </td>
      <td class="months12">Months 1-12:</td>
      <td>
        <xsl:value-of select="substring(paymentHistory/paymentPattern/text,1,12)"/>
      </td>
    </tr>
    <tr>
      <td>Amount:</td>
      <td>
        <xsl:choose>
          <xsl:when test="string(number(paymentHistory/maxDelinquency/amount))='NaN'">&#160;</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(paymentHistory/maxDelinquency/amount, '$###,###,##0')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td></td>
      <td></td>
      <td>Months 13-24:</td>
      <td>
        <xsl:value-of select="substring(paymentHistory/paymentPattern/text,13,12)"/>
      </td>
    </tr>
    <tr class="lastRow">
      <td></td>
      <td></td>
      <td>Date:</td>
      <td>
        <xsl:value-of select="ms:format-date(paymentHistory/maxDelinquency/date, 'MM/yy')"/>
      </td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
  </xsl:template>

  <xsl:template  match ="product/subject/subjectRecord/custom/credit/collection">
    <tr class="firstRow">
      <td colspan="2">
        <xsl:value-of select="subscriber/name/unparsed"/> (<xsl:value-of select="subscriber/industryCode"/>&#160;<xsl:value-of select="subscriber/memberCode"/>)
      </td>
      <td colspan="2">
        Account # <xsl:value-of select="accountNumber"/>
      </td>
      <td colspan="2"></td>
      <td colspan="2">
        Account Rating <xsl:value-of select="accountRating"/>
      </td>
    </tr>
    <tr>
      <td>Original Creditor:</td>
      <td>
        <xsl:apply-templates select ="original/creditGrantor/unparsed" />&#160;
        <xsl:if test="count(original/creditorClassification) !=0">(<xsl:value-of select="original/creditorClassification"/>)</xsl:if>
      </td>
      <td>
        Remarks:
      </td>
      <td>
        <xsl:apply-templates select ="remark/code" />
      </td>
      <td>
        Amount Placed:
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(number(original/balance))='NaN'"></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(original/balance, '$###,###,##0')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        Opened:
      </td>
      <td>
        <xsl:value-of select="ms:format-date(dateOpened, 'MM/yy')"/>
      </td>
    </tr>
    <tr>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td>Balance:</td>
      <td>
        <xsl:choose>
          <xsl:when test="string(number(currentBalance))='NaN'"></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(currentBalance, '$###,###,##0')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>Paid:</td>
      <td>
        <xsl:value-of select="ms:format-date(datePaidOut, 'MM/yy')"/>
      </td>
    </tr>
    <tr>
      <td>Account Type:</td>
      <td>
        <xsl:value-of select="portfolioType"/>
      </td>
      <td></td>
      <td></td>
      <td>Past Due:</td>
      <td>
        <xsl:choose>
          <xsl:when test="string(number(pastDue))='NaN'"></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(pastDue, '$###,###,##0')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>Closed:</td>
      <td>
        <xsl:value-of select="ms:format-date(dateClosed, 'MM/yy')"/>
      </td>
    </tr>
    <tr>
      <td>Responsibility:</td>
      <td>
        <xsl:value-of select="ECOADesignator"/>
      </td>
      <td></td>
      <td></td>
      <td>Last Payment:</td>
      <td>
        <xsl:choose>
          <xsl:when test="string(number(mostRecentPayment/amount))='NaN'"></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(mostRecentPayment/amount, '$###,###,##0')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>Verified:</td>
      <td>
        <xsl:value-of select="ms:format-date(dateEffective, 'MM/yy')"/>
      </td>
    </tr>
    <tr class="lastRow">
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td>Update Method:</td>
      <td>
        <xsl:value-of select="updateMethod"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template  match ="product/subject/subjectRecord/custom/credit/inquiry">
    <tr>
      <td>
        <xsl:value-of select="ms:format-date(date, 'MM/dd/yyyy')"/>
      </td>
      <td>
        <xsl:value-of select="subscriber/name/unparsed"/>&#160;(<xsl:value-of select="subscriber/industryCode"/>&#160;<xsl:value-of select="subscriber/memberCode"/>)
      </td>
    </tr>
  </xsl:template>

  <xsl:template  match ="product/subject/subjectRecord/custom/credit/publicRecord">
    <tr class="firstRow">
      <td colspan="2">
        <xsl:value-of select="subscriber/industryCode"/>&#160;
        <xsl:value-of select="subscriber/memberCode"/>
      </td>
      <td colspan="2">
        Docket#&#160;<xsl:value-of select="docketNumber"/>
      </td>
      <td colspan="4"></td>
    </tr>
    <tr>
      <td>
        Type:
      </td>
      <td>
        <xsl:apply-templates select ="type" />
      </td>
      <td>
        Location:
      </td>
      <td>
        <xsl:apply-templates select="source/address"/>
      </td>
      <td></td>
      <td></td>
      <td>Filed:</td>
      <td>
        <xsl:value-of select="ms:format-date(dateFiled, 'MM/yy')"/>
      </td>
    </tr>
    <tr>
      <td>Court:</td>
      <td>
        <xsl:value-of select="source/type"/>
      </td>
      <td>
        Plaintiff:
      </td>
      <td>
        <xsl:value-of select="plaintiff"/>
      </td>
      <td>
        Liabilities:
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(number(liabilities))='NaN'"></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(liabilities, '$###,###,##0')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        Effective:
      </td>
      <td>
        <xsl:value-of select="ms:format-date(dateReported, 'MM/yy')"/>
      </td>
    </tr>
    <tr>
      <td>Responsibility:</td>
      <td>
        <xsl:value-of select="ECOADesignator"/>
      </td>
      <td>
        Attorney:
      </td>
      <td>
        <xsl:value-of select="attorney"/>
      </td>
      <td>
        Orig Balance:
      </td>
      <td>
      </td>
      <td>
        Paid:
      </td>
      <td>
        <xsl:value-of select="ms:format-date(datePaid, 'MM/yy')"/>
      </td>
    </tr>
    <tr class="lastRow">
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td>Curr Balance:</td>
      <td></td>
      <td></td>
      <td></td>
    </tr>

  </xsl:template>

  <xsl:template match ="source/address">
    <xsl:call-template name ="address"/>
  </xsl:template>

  <xsl:template match ="account/type">
    <xsl:call-template name ="accountType"/>
  </xsl:template>

  <xsl:template match ="type">
    <xsl:call-template name ="publicType" />
  </xsl:template>
  
  <xsl:template match="accountRating">
    <xsl:choose>
      <xsl:when test="text()='01'">Paid as agreed</xsl:when>
      <xsl:when test="text()='02'">30 days past due</xsl:when>
      <xsl:when test="text()='03'">60 days past due</xsl:when>
      <xsl:when test="text()='04'">90 days past due</xsl:when>
      <xsl:when test="text()='05'">120 days past due</xsl:when>
      <xsl:when test="text()='07'">120 days past due</xsl:when>
      <xsl:when test="text()='08'">Repossesion</xsl:when>
      <xsl:when test="text()='8A'">Voluntary surrender</xsl:when>
      <xsl:when test="text()='8P'">Paymt. after repo.</xsl:when>
      <xsl:when test="text()='09'">Charged off bad debt</xsl:when>
      <xsl:when test="text()='9B'">Collection</xsl:when>
      <xsl:when test="text()='9P'">Paymt. after coll.</xsl:when>
      <xsl:when test="text()='UR'">Unrated or bk.</xsl:when>
      <xsl:otherwise>
        NA
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="accountType">
    <xsl:choose>
      <xsl:when test="text()='AF'">Appliance | Furniture</xsl:when>
      <xsl:when test="text()='AG'">Collection Agency | Attorney</xsl:when>
      <xsl:when test="text()='AL'">Auto Lease</xsl:when>
      <xsl:when test="text()='AU'">Automobile</xsl:when>
      <xsl:when test="text()='AX'">Agricultural Loan</xsl:when>
      <xsl:when test="text()='BC'">Business Credit Card</xsl:when>
      <xsl:when test="text()='BL'">Revolving Business Lines</xsl:when>
      <xsl:when test="text()='BU'">Business</xsl:when>
      <xsl:when test="text()='CB'">Combined Credit Plan</xsl:when>
      <xsl:when test="text()='CC'">Credit Card</xsl:when>
      <xsl:when test="text()='CE'">Commercial Line of Credit</xsl:when>
      <xsl:when test="text()='CH'">Charge Account</xsl:when>
      <xsl:when test="text()='CI'">Commercial Installment Loan</xsl:when>
      <xsl:when test="text()='CO'">Consolidation</xsl:when>
      <xsl:when test="text()='CP'">Child Support</xsl:when>
      <xsl:when test="text()='CR'">Cond. Sales Contract | Refinance</xsl:when>
      <xsl:when test="text()='CU'">Telecommunications | Cellular</xsl:when>
      <xsl:when test="text()='CV'">Conventional Real Estate Mortgage</xsl:when>
      <xsl:when test="text()='CY'">Commercial Mortgage</xsl:when>
      <xsl:when test="text()='DC'">Debit Card</xsl:when>
      <xsl:when test="text()='DR'">Deposit Account with Overdraft Protection</xsl:when>
      <xsl:when test="text()='DS'">Debt Counseling Service</xsl:when>
      <xsl:when test="text()='EM'">Employment</xsl:when>
      <xsl:when test="text()='FC'">Factoring Company Account</xsl:when>
      <xsl:when test="text()='FD'">Fraud Identify Check</xsl:when>
      <xsl:when test="text()='FE'">Attorney Fees</xsl:when>
      <xsl:when test="text()='FI'">FHA Home Improvement</xsl:when>
      <xsl:when test="text()='FL'">FMHA Real Estate Mortgage</xsl:when>
      <xsl:when test="text()='FM'">Family Support</xsl:when>
      <xsl:when test="text()='FR'">FHA Real Estate Mortgage</xsl:when>
      <xsl:when test="text()='FT'">Collection Credit Report Inquiry</xsl:when>
      <xsl:when test="text()='FX'">FX Flexible Spending Credit Card</xsl:when>
      <xsl:when test="text()='GA'">Government Employee Advance</xsl:when>
      <xsl:when test="text()='GE'">Government Fee for Services</xsl:when>
      <xsl:when test="text()='GF'">Government Fines</xsl:when>
      <xsl:when test="text()='GG'">Government Grant</xsl:when>
      <xsl:when test="text()='GO'">Government Overpayment</xsl:when>
      <xsl:when test="text()='GS'">Government Secured</xsl:when>
      <xsl:when test="text()='GU'">Govt. Unsecured Guar | Dir Ln</xsl:when>
      <xsl:when test="text()='GV'">Government</xsl:when>
      <xsl:when test="text()='HE'">Home Equity Loan</xsl:when>
      <xsl:when test="text()='HG'">Household Goods</xsl:when>
      <xsl:when test="text()='HI'">Home Improvement</xsl:when>
      <xsl:when test="text()='IE'">ID Report for Employment</xsl:when>
      <xsl:when test="text()='IS'">Installment Sales Contract</xsl:when>
      <xsl:when test="text()='LC'">Line of Credit</xsl:when>
      <xsl:when test="text()='LE'">Lease</xsl:when>
      <xsl:when test="text()='LI'">Lender-placed Insurance</xsl:when>
      <xsl:when test="text()='LN'">Construction Loan</xsl:when>
      <xsl:when test="text()='LS'">Credit Line Secured</xsl:when>
      <xsl:when test="text()='MB'">Manufactured Housing</xsl:when>
      <xsl:when test="text()='MD'">Medical Debt</xsl:when>
      <xsl:when test="text()='MH'">Medical | Health Care</xsl:when>
      <xsl:when test="text()='NT'">Note Loan</xsl:when>
      <xsl:when test="text()='PS'">Partly Secured</xsl:when>
      <xsl:when test="text()='RA'">Rental Agreement</xsl:when>
      <xsl:when test="text()='RC'">Returned Check</xsl:when>
      <xsl:when test="text()='RD'">Recreational Merchandise</xsl:when>
      <xsl:when test="text()='RE'">Real Estate</xsl:when>
      <xsl:when test="text()='RL'">Real Estate — Junior Liens</xsl:when>
      <xsl:when test="text()='RM'">Real Estate Mortgage</xsl:when>
      <xsl:when test="text()='SA'">Summary of Accounts — Same Status</xsl:when>
      <xsl:when test="text()='SC'">Secured Credit Card</xsl:when>
      <xsl:when test="text()='SE'">Secured</xsl:when>
      <xsl:when test="text()='SF'">Secondary Use of a Credit Report for Auto Financing</xsl:when>
      <xsl:when test="text()='SH'">Secured by Household Goods</xsl:when>
      <xsl:when test="text()='SI'">Secured Home Improvement</xsl:when>
      <xsl:when test="text()='SM'">Second Mortgage</xsl:when>
      <xsl:when test="text()='SO'">Secured by Household Goods and Collateral</xsl:when>
      <xsl:when test="text()='SR'">Secondary Use of a Credit Report</xsl:when>
      <xsl:when test="text()='ST'">Student Loan</xsl:when>
      <xsl:when test="text()='SU'">Spouse Support</xsl:when>
      <xsl:when test="text()='SX'">Secondary Use of a Credit Report for Other Financing</xsl:when>
      <xsl:when test="text()='TS'">Time Shared Loan</xsl:when>
      <xsl:when test="text()='UC'">Utility Company</xsl:when>
      <xsl:when test="text()='UK'">Unknown</xsl:when>
      <xsl:when test="text()='US'">Unsecured</xsl:when>
      <xsl:when test="text()='VM'">V.A. Real Estate Mortgage</xsl:when>
      <xsl:when test="text()='WT'">Individual Monitoring Report Inquiry</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="text()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match ="remark/code">
    <xsl:call-template name ="remarkCode"/>
  </xsl:template>

  <xsl:template name="remarkCode">
    <xsl:choose>
      <xsl:when test="text()='BKL'">Included in bankruptcy</xsl:when>
      <xsl:when test="text()='BKW'">Bankruptcy withdrawn</xsl:when>
      <xsl:when test="text()='CBL'">Chapter 7 bankruptcy</xsl:when>
      <xsl:when test="text()='CBR'">Chapter 11 bankruptcy</xsl:when>
      <xsl:when test="text()='CBT'">Chapter 12 bankruptcy</xsl:when>
      <xsl:when test="text()='DM'">Bankruptcy dismissed</xsl:when>
      <xsl:when test="text()='LA'">Lease assumption</xsl:when>
      <xsl:when test="text()='PRS'">Personal receivership</xsl:when>
      <xsl:when test="text()='REA'">Reaffirmation of debt</xsl:when>
      <xsl:when test="text()='WEP'">Charged off bad debt</xsl:when>
      <xsl:when test="text()='AID'">Information disputed</xsl:when>
      <xsl:when test="text()='CAD'">Dispute | closed by consumer</xsl:when>
      <xsl:when test="text()='CBC'">Account closed by consumer</xsl:when>
      <xsl:when test="text()='CBD'">Dispute resolved | consumer disagrees</xsl:when>
      <xsl:when test="text()='DRC'">Dispute resolved | subscriber disagrees</xsl:when>
      <xsl:when test="text()='DRG'">Dispute resolved reported by grantor</xsl:when>
      <xsl:when test="text()='CLA'">Placed for collection</xsl:when>
      <xsl:when test="text()='CLO'">Closed</xsl:when>
      <xsl:when test="text()='DLU'">Deed in lieu</xsl:when>
      <xsl:when test="text()='FPD'">Account paid, foreclosure started</xsl:when>
      <xsl:when test="text()='FRD'">Foreclosure, collateral sold</xsl:when>
      <xsl:when test="text()='PCL'">Paid collection</xsl:when>
      <xsl:when test="text()='PLP'">Profit and loss now paying</xsl:when>
      <xsl:when test="text()='PPL'">Paid profit and loss</xsl:when>
      <xsl:when test="text()='PRL'">Profit and loss write-off</xsl:when>
      <xsl:when test="text()='RFN'">Refinanced</xsl:when>
      <xsl:when test="text()='RPD'">Paid repossession</xsl:when>
      <xsl:when test="text()='RPO'">Repossession</xsl:when>
      <xsl:when test="text()='RVN'">Voluntary surrender</xsl:when>
      <xsl:when test="text()='SGL'">Claim filed with government</xsl:when>
      <xsl:when test="text()='TRF'">Transfer</xsl:when>
      <xsl:when test="text()='AAP'">Loan assumed by another party</xsl:when>
      <xsl:when test="text()='ACQ'">Acquired from another lender</xsl:when>
      <xsl:when test="text()='ACR'">Account closed due to refinance</xsl:when>
      <xsl:when test="text()='ACT'">Account closed due to transfer</xsl:when>
      <xsl:when test="text()='AFR'">Account acquired by RTC|FDIC|NCUA</xsl:when>
      <xsl:when test="text()='AJP'">Adjustment pending</xsl:when>
      <xsl:when test="text()='AMD'">Active military duty</xsl:when>
      <xsl:when test="text()='AND'">Affected by natural|declared disaster</xsl:when>
      <xsl:when test="text()='BAL'">Balloon payment</xsl:when>
      <xsl:when test="text()='CBG'">Account closed by credit grantor</xsl:when>
      <xsl:when test="text()='CLB'">Contingent liability—corporate defaults</xsl:when>
      <xsl:when test="text()='CLC'">Account closed</xsl:when>
      <xsl:when test="text()='CLR'">Credit line reduced due to collateral depreciation</xsl:when>
      <xsl:when test="text()='CLS'">Credit line suspended</xsl:when>
      <xsl:when test="text()='CPB'">Subscriber pays balance in full each month</xsl:when>
      <xsl:when test="text()='CRB'">Collateral released by creditor/balance owing</xsl:when>
      <xsl:when test="text()='CTR'">Account closed—transfer or refinance</xsl:when>
      <xsl:when test="text()='CTS'">Contact subscriber</xsl:when>
      <xsl:when test="text()='ER'">Election of remedy</xsl:when>
      <xsl:when test="text()='ETB'">Early termination|balance owing</xsl:when>
      <xsl:when test="text()='ETI'">Early termination|insurance loss</xsl:when>
      <xsl:when test="text()='ETO'">Early termination|obligation satisfied</xsl:when>
      <xsl:when test="text()='ETS'">Early termination|status pending</xsl:when>
      <xsl:when test="text()='FCL'">Foreclosure</xsl:when>
      <xsl:when test="text()='FOR'">Account in forbearance</xsl:when>
      <xsl:when test="text()='FPD'">Account paid, foreclosure started</xsl:when>
      <xsl:when test="text()='FPI'">Foreclosure initiated</xsl:when>
      <xsl:when test="text()='FTB'">Full termination|balance owing</xsl:when>
      <xsl:when test="text()='FTO'">Full termination|obligation satisfied</xsl:when>
      <xsl:when test="text()='FTS'">Full termination|status pending</xsl:when>
      <xsl:when test="text()='INA'">Inactive account</xsl:when>
      <xsl:when test="text()='INP'">Debt being paid through insurance</xsl:when>
      <xsl:when test="text()='INS'">Paid by insurance</xsl:when>
      <xsl:when test="text()='IRB'">Involuntary repossession|balance owing</xsl:when>
      <xsl:when test="text()='IRE'">Involuntary repossession</xsl:when>
      <xsl:when test="text()='IRO'">Involuntary repossession|obligation satisfied</xsl:when>
      <xsl:when test="text()='JUG'">Judgment granted</xsl:when>
      <xsl:when test="text()='LMD'">Loan modified under federal government plan</xsl:when>
      <xsl:when test="text()='LMN'">Loan modified non-government</xsl:when>
      <xsl:when test="text()='LNA'">Credit line no longer available – in repayment phase</xsl:when>
      <xsl:when test="text()='MCC'">Managed by debt counseling service</xsl:when>
      <xsl:when test="text()='MOV'">No forwarding address</xsl:when>
      <xsl:when test="text()='NIR'">Student loan not in repayment</xsl:when>
      <xsl:when test="text()='NPA'">Now paying</xsl:when>
      <xsl:when test="text()='PAL'">Purchased by another lender</xsl:when>
      <xsl:when test="text()='PDD'">Paid by dealer</xsl:when>
      <xsl:when test="text()='PDE'">Payment deferred</xsl:when>
      <xsl:when test="text()='PDI'">Principal deferred|interest payment only</xsl:when>
      <xsl:when test="text()='PFC'">Account paid from collateral</xsl:when>
      <xsl:when test="text()='PLL'">Prepaid lease</xsl:when>
      <xsl:when test="text()='PNR'">First payment never received</xsl:when>
      <xsl:when test="text()='PPA'">Paying under partial or modified payment agreement</xsl:when>
      <xsl:when test="text()='PPD'">Paid by co-maker</xsl:when>
      <xsl:when test="text()='PRD'">Payroll deduction</xsl:when>
      <xsl:when test="text()='PWG'">Account payment, wage garnish</xsl:when>
      <xsl:when test="text()='REP'">Substitute|Replacement account</xsl:when>
      <xsl:when test="text()='RRE'">Repossession, redeemed</xsl:when>
      <xsl:when test="text()='RVR'">Voluntary surrender redeemed</xsl:when>
      <xsl:when test="text()='SCD'">Credit line suspended due to collateral depreciation</xsl:when>
      <xsl:when test="text()='SET'">Settled—less than full balance</xsl:when>
      <xsl:when test="text()='SIL'">Simple interest loan</xsl:when>
      <xsl:when test="text()='SLP'">Student loan perm assign government</xsl:when>
      <xsl:when test="text()='SPL'">Single payment loan</xsl:when>
      <xsl:when test="text()='STL'">Credit card lost or stolen</xsl:when>
      <xsl:when test="text()='TRL'">Transferred to another lender</xsl:when>
      <xsl:when test="text()='TTR'">Transferred to recovery</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="text()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name ="publicType">
    <xsl:choose>
      <xsl:when test="text()='AM'">Attachment</xsl:when>
      <xsl:when test="text()='CB'">Civil judgment in bankruptcy</xsl:when>
      <xsl:when test="text()='CJ'">Civil judgment</xsl:when>
      <xsl:when test="text()='CP'">Child support</xsl:when>
      <xsl:when test="text()='CS'">Civil suit filed</xsl:when>
      <xsl:when test="text()='DF'">Dismissed foreclosure</xsl:when>
      <xsl:when test="text()='DS'">Dismissal of court suit</xsl:when>
      <xsl:when test="text()='FC'">Foreclosure</xsl:when>
      <xsl:when test="text()='FD'">Forcible detainer</xsl:when>
      <xsl:when test="text()='FF'">Forcible detainer dismissed</xsl:when>
      <xsl:when test="text()='FT'">Federal tax lien</xsl:when>
      <xsl:when test="text()='GN'">Garnishment</xsl:when>
      <xsl:when test="text()='HA'">Homeowners association assessment lien</xsl:when>
      <xsl:when test="text()='HF'">Hospital lien satisfied</xsl:when>
      <xsl:when test="text()='HL'">Hospital lien</xsl:when>
      <xsl:when test="text()='JL'">Judicial lien</xsl:when>
      <xsl:when test="text()='JM'">Judgment dismissed</xsl:when>
      <xsl:when test="text()='LR'">A lien attached to real property</xsl:when>
      <xsl:when test="text()='ML'">Mechanics lien</xsl:when>
      <xsl:when test="text()='PC'">Paid civil judgment</xsl:when>
      <xsl:when test="text()='PF'">Paid federal tax lien</xsl:when>
      <xsl:when test="text()='PG'">Paving assessment lien</xsl:when>
      <xsl:when test="text()='PL'">Paid tax lien</xsl:when>
      <xsl:when test="text()='PQ'">Paving assessment lien satisfied</xsl:when>
      <xsl:when test="text()='PT'">Puerto Rico tax lien</xsl:when>
      <xsl:when test="text()='PV'">Judgment paid, vacated</xsl:when>
      <xsl:when test="text()='RL'">Release of tax lien</xsl:when>
      <xsl:when test="text()='RM'">Release of mechanics lien</xsl:when>
      <xsl:when test="text()='RS'">Real estate attachment satisfied</xsl:when>
      <xsl:when test="text()='SF'">Satisfied foreclosure</xsl:when>
      <xsl:when test="text()='SL'">State tax lien</xsl:when>
      <xsl:when test="text()='TB'">Tax lien included in bankruptcy</xsl:when>
      <xsl:when test="text()='TC'">Trusteeship canceled</xsl:when>
      <xsl:when test="text()='TL'">Tax lien</xsl:when>
      <xsl:when test="text()='TP'">Trusteeship paid | state amortization satisfied</xsl:when>
      <xsl:when test="text()='TR'">Trusteeship paid | state amortization</xsl:when>
      <xsl:when test="text()='TX'">Tax lien revived</xsl:when>
      <xsl:when test="text()='WS'">Water and sewer lien</xsl:when>
      <xsl:when test="text()='1D'">Chapter 11 bankruptcy dismissed</xsl:when>
      <xsl:when test="text()='1F'">Chapter 11 bankruptcy filing</xsl:when>
      <xsl:when test="text()='1V'">Chapter 11 bankruptcy voluntary dismissal</xsl:when>
      <xsl:when test="text()='1X'">Chapter 11 bankruptcy discharged</xsl:when>
      <xsl:when test="text()='2D'">Chapter 12 bankruptcy dismissed</xsl:when>
      <xsl:when test="text()='2F'">Chapter 12 bankruptcy filing</xsl:when>
      <xsl:when test="text()='2V'">Chapter 12 bankruptcy voluntary dismissal</xsl:when>
      <xsl:when test="text()='2X'">Chapter 12 bankruptcy discharged</xsl:when>
      <xsl:when test="text()='3D'">Chapter 13 bankruptcy dismissed</xsl:when>
      <xsl:when test="text()='3F'">Chapter 13 bankruptcy filing</xsl:when>
      <xsl:when test="text()='3V'">Chapter 13 bankruptcy voluntary dismissal</xsl:when>
      <xsl:when test="text()='3X'">Chapter 13 bankruptcy discharged</xsl:when>
      <xsl:when test="text()='7D'">Chapter 7 bankruptcy dismissed</xsl:when>
      <xsl:when test="text()='7F'">Chapter 7 bankruptcy filing</xsl:when>
      <xsl:when test="text()='7V'">Chapter 7 bankruptcy voluntary dismissal</xsl:when>
      <xsl:when test="text()='7X'">Chapter 7 bankruptcy discharged</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="text()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match ="product/subject/subjectRecord/addOnProduct/creditorContact">
    <div class="contact">
      <div>
        <div>
          <xsl:value-of select="subscriber/name/unparsed"/>&#160;(<xsl:value-of select="subscriber/industryCode"/>&#160;<xsl:value-of select="subscriber/memberCode"/>)
        </div>
        <div>
          <xsl:apply-templates select ="subscriber/address"/>&#160;
        </div>
        <div>
          <xsl:apply-templates select ="subscriber/phone"/>&#160;
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="subscriber/address">
    <xsl:value-of select="street/unparsed"/><br/>
    <xsl:value-of select="location/city"/>&#160;<xsl:value-of select="location/state"/>&#160;<xsl:value-of select="location/zipCode"/>
  </xsl:template>

  <xsl:template match="subscriber/phone">
    Phone:
    (<xsl:value-of select="number/areaCode"/>)&#160;<xsl:value-of select="number/exchange"/>-<xsl:value-of select="number/suffix"/>
  </xsl:template>

</xsl:stylesheet>

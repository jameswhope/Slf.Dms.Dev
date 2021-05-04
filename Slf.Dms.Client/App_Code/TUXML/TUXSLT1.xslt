<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
xmlns:ms="urn:schemas-microsoft-com:xslt">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/creditBureau">
      <div>
        <div class="mainHeader">
          TRANSUNION CREDIT REPORT
        </div>
        <div class="section">
          <xsl:apply-templates select="transactionControl" />
        </div>  
        <div class="section">
          <xsl:apply-templates select="product/subject/subjectRecord/indicative" />
        </div>
        <div class="section">
          <div class="header">
            TRADES
          </div>
          <xsl:apply-templates select="product/subject/subjectRecord/custom/credit/trade" />
        </div>
        <div class="section">
          <div class="header">
            COLLECTIONS  
          </div>
          <xsl:apply-templates select="product/subject/subjectRecord/custom/credit/collection" />
        </div>
        <div class="section">
          <div class="header">
            INQUIRIES
          </div>
          <div>
            <div class="content">
              <table class="tb">
                <thead>
                  <tr>
                    <th>Creditor Name</th>
                    <th>Date of Inquiry</th>
                  </tr>
                </thead>
                <tbody>
                  <xsl:apply-templates select="product/subject/subjectRecord/custom/credit/inquiry" />
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="section">
          <div class="header">
            PUBLIC RECORDS
          </div>
          <xsl:apply-templates select="product/subject/subjectRecord/custom/credit/publicRecord" />
        </div>
    </div>
  </xsl:template>

  <xsl:template match="transactionControl">
    <div class="content">
      <table class="tb">
      <thead>
        <tr>
          <th>FOR</th>
          <th>Sub Name</th>
          <th>Mkt Sub</th>
          <th>In File Since</th>
          <th>Date</th>
          <th>Time</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>
            <xsl:value-of select="subscriber/inquirySubscriberPrefixCode"/>
            (<xsl:value-of select="subscriber/industryCode"/>)
          </td>
          <td>
            <xsl:value-of select="subscriber/memberCode"/>
          </td>
          <td>
            <xsl:value-of select="//product/subject/subjectRecord/fileSummary/market"/>
            &#160;
            <xsl:value-of select="//product/subject/subjectRecord/fileSummary/submarket"/>
          </td>
          <td>
            <xsl:value-of select="//product/subject/subjectRecord/fileSummary/inFileSinceDate"/>
          </td>
          <td>
            <xsl:value-of select="ms:format-date(tracking/transactionTimeStamp, 'MM/dd/yyyy')"/>
          </td>
          <td>
            <xsl:value-of select="ms:format-time(tracking/transactionTimeStamp, 'HH:mm:ss tt')"/>
          </td>
        </tr>
      </tbody>
    </table>
    </div>
  </xsl:template>

  <xsl:template match ="product/subject/subjectRecord/indicative">
    <div>
      <div class="header">
          SUBJECT
      </div>
      <div  class="content">
        <table class="tb">
        <thead>
          <tr>
            <th>Name</th>
            <th>SSN</th>
            <th>Birth Date</th>
            <th>Telephone</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>
              <b>
                <xsl:value-of select="name/person/last"/>,
                <xsl:value-of select="name/person/first"/> &#160;
                <xsl:value-of select="name/person/middle"/>
              </b>
              <xsl:apply-templates select ="name/qualifier[text()='alsoKnownAs']" />
            </td>
            <td>
              <xsl:value-of select="format-number(socialSecurity/number,'###-##-####')"/>
            </td>
            <td>
              <xsl:value-of select="ms:format-date(dateOfBirth, 'MM/dd/yyyy')"/>
            </td>
            <td>
              (<xsl:value-of select="phone/number/areaCode"/>)-
              <xsl:value-of select="phone/number/exchange"/>-
              <xsl:value-of select="phone/number/suffix"/>
            </td>
          </tr>
        </tbody>
      </table>
      </div>
    </div>
    <div>
      <div class="header">
        ADDRESS
      </div>
      <div class="content">
        <table class="tb">
          <thead>
            <tr>
              <th>Status</th>
              <th>Address</th>
              <th>Date Reported</th>
            </tr>
          </thead>
          <tbody>
            <xsl:apply-templates select="address" />
          </tbody>
        </table>
      </div>
    </div>
    <div>
      <div class="header">
        EMPLOYMENT
      </div>
      <div class="content">
      <table class="tb">
        <thead>
          <tr>
            <th>Employer and Address</th>
            <th>Occupation</th>
            <th>Date Hired</th>
            <th>Date Terminated</th>
            <th>Date Reported</th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="employment" />
        </tbody>
      </table>
     </div>
    </div>
  </xsl:template>

  <xsl:template match ="name/qualifier[text()='alsoKnownAs']">
    <xsl:if test ="position()=1">
      <br/><br/><i>Also known as</i>
    </xsl:if>
    <br/><xsl:value-of select="ancestor::name/person/unparsed"/>
  </xsl:template>

  <xsl:template match="address" >
    <tr>
      <td>
        <xsl:value-of select="status"/>
      </td>
      <td>
        <xsl:call-template name ="address"/>
      </td>
      <td>
        <xsl:value-of select="ms:format-date(dateReported, 'MM/dd/yyyy')"/>
      </td>
    </tr>
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
    <tr>
      <td>
        <xsl:value-of select="employer/unparsed"/><br/>
        <xsl:call-template name ="address"/>
      </td>
      <td>
        <xsl:value-of select="occupation"/>
      </td>
      <td>
        <xsl:value-of select="ms:format-date(dateHired, 'MM/dd/yyyy')"/>
      </td>
      <td>
        <xsl:value-of select="ms:format-date(dateTerminated, 'MM/dd/yyyy')"/>
      </td>
      <td>
        <xsl:value-of select="ms:format-date(dateOnFileSince, 'MM/dd/yyyy')"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template  match ="product/subject/subjectRecord/custom/credit/trade">
    <div class="content">
      <table class="tb">
        <thead>
          <tr>
            <th colspan="6">
              <xsl:value-of select="subscriber/name/unparsed"/>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Account #:</td>
            <td>
              <xsl:value-of select="accountNumber"/>
            </td>
            <td>Type:</td>
            <td>
              <xsl:value-of select="portfolioType"/>
            </td>
            <td>Opened:</td>
            <td>
              <xsl:value-of select="ms:format-date(dateOpened, 'MM/dd/yyyy')"/>
            </td>
          </tr>
          <tr>
            <td>Condition:</td>
            <td></td>
            <td>Pay status:</td>
            <td>
              <xsl:apply-templates select ="accountRating" />
            </td>
            <td>Reported:</td>
            <td>
              <xsl:value-of select="ms:format-date(dateEffective, 'MM/dd/yyyy')"/>
            </td>
          </tr>
          <tr>
            <td>Balance:</td>
            <td>
              <xsl:choose>
                <xsl:when test="string(number(currentBalance))='NaN'">$0.00</xsl:when>
                <xsl:otherwise>
                   <xsl:value-of select="format-number(currentBalance, '$###,###,##0.00')"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>Payment:</td>
            <td>
              <xsl:choose>
                <xsl:when test="string(number(terms/scheduledMonthlyPayment))='NaN'">$0.00</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="format-number(terms/scheduledMonthlyPayment, '$###,###,##0.00')"/>&#160;monthly<br/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>Responsibility:</td>
            <td>
              <xsl:value-of select="ECOADesignator"/>
            </td>
          </tr>
          <tr>
            <td>High Balance:</td>
            <td>
              <xsl:choose>
                <xsl:when test="string(number(highCredit))='NaN'">$0.00</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="format-number(highCredit, '$###,###,##0.00')"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>Frecuency:</td>
            <td>
              <xsl:value-of select="terms/paymentFrequency"/>
            </td>
            <td>Past Due:</td>
            <td>
              <xsl:choose>
                <xsl:when test="string(number(pastDue))='NaN'">$0.00</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="format-number(pastDue, '$###,###,##0.00')"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr>
            <td>Remarks:</td>
            <td>
              <xsl:value-of select="remark/code"/>
            </td>
            <td>Limit:</td>
            <td>
              <xsl:choose>
                <xsl:when test="string(number(creditLimit))='NaN'">$0.00</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="format-number(creditLimit, '$###,###,##0.00')"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>Date Closed:</td>
            <td>
              <xsl:value-of select="ms:format-date(dateClosed, 'MM/dd/yyyy')"/>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
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
  <xsl:template  match ="product/subject/subjectRecord/custom/credit/collection">
    <div class="content">
      <table class="tb">
        <thead >
          <tr>
            <th colspan="6">
              <xsl:value-of select="subscriber/name/unparsed"/>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Account #:</td>
            <td>
              <xsl:value-of select="accountNumber"/>
            </td>
            <td>Type:</td>
            <td>
              <xsl:value-of select="portfolioType"/>
            </td>
            <td>Opened:</td>
            <td>
              <xsl:value-of select="ms:format-date(dateOpened, 'MM/dd/yyyy')"/>
            </td>
          </tr>
          <tr>
            <td>Original:</td>
            <td>
              <xsl:apply-templates select ="original/creditGrantor/unparsed" />
            </td>
            <td>Status:</td>
            <td>
              <xsl:apply-templates select ="accountRating" />
            </td>
            <td>Reported:</td>
            <td>
              <xsl:value-of select="ms:format-date(dateEffective, 'MM/dd/yyyy')"/>
            </td>
          </tr>
          <tr>
            <td>Balance:</td>
            <td>
              <xsl:choose>
                <xsl:when test="string(number(original/balance))='NaN'">$0.00</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="format-number(original/balance, '$###,###,##0.00')"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>Past Due:</td>
            <td>
              <xsl:choose>
                <xsl:when test="string(number(pastDue))='NaN'">$0.00</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="format-number(pastDue, '$###,###,##0.00')"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>Responsibility:</td>
            <td>
              <xsl:value-of select="ECOADesignator"/>
            </td>
          </tr>
          <tr>
            <td>Classification:</td>
            <td>
              <xsl:value-of select="original/creditorClassification"/>
            </td>
            <td></td>
            <td></td>
            <td>Closed Indicator:</td>
            <td>
              <xsl:value-of select="closedIndicator"/>
            </td>
          </tr>
          <tr>
            <td>Remarks:</td>
            <td>
              <xsl:value-of select="remark/code"/>
            </td>
            <td></td>
            <td>
            </td>
            <td>Date Closed:</td>
            <td>
              <xsl:value-of select="ms:format-date(dateClosed, 'MM/dd/yyyy')"/>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </xsl:template>
  <xsl:template  match ="product/subject/subjectRecord/custom/credit/inquiry">
    <tr>
      <td>
        <xsl:value-of select="subscriber/name/unparsed"/>
      </td>
      <td>
        <xsl:value-of select="ms:format-date(date, 'MM/dd/yyyy')"/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template  match ="product/subject/subjectRecord/custom/credit/publicRecord">
    <div class="content">
      <table class="tb">
        <thead>
          <tr>
            <th colspan="6">
              <xsl:value-of select="subscriber/name/unparsed"/>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Type:</td>
            <td>
              <xsl:value-of select="type"/>
            </td>
            <td>Court #:</td>
            <td>
              <xsl:value-of select="docketNumber"/>
            </td>
            <td>Date Filed:</td>
            <td>
              <xsl:value-of select="ms:format-date(dateFiled, 'MM/dd/yyyy')"/>
            </td>
          </tr>
          <tr>
            <td>Attorney:</td>
            <td>
              <xsl:value-of select="attorney"/>
            </td>
            <td>Date Paid:</td>
            <td>
              <xsl:value-of select="ms:format-date(datePaid, 'MM/dd/yyyy')"/>
            </td>
            <td>Date Reported:</td>
            <td>
              <xsl:value-of select="ms:format-date(dateReported, 'MM/dd/yyyy')"/>
            </td>
          </tr>
          <tr>
            <td>Plaintiff:</td>
            <td>
              <xsl:value-of select="plaintiff"/>
            </td>
            <td>Liabilities:</td>
            <td>
              <xsl:value-of select="format-number(liabilities, '$###,###,##0.00')"/>
            </td>
            <td>Responsibility:</td>
            <td>
              <xsl:value-of select="ECOADesignator"/>
            </td>
          </tr>
          <tr>
            <td>Source:</td>
            <td>
              <xsl:value-of select="source/type"/>
            </td>
            <td></td>
            <td>
            </td>
            <td></td>
            <td>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </xsl:template>
</xsl:stylesheet>

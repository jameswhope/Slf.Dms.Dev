function DateClass(d) {
    this.date = d;
}

DateClass.prototype.addMonths = function(value) {
    var n = this.date.getDate();
    this.date.setDate(1);
    this.date.setMonth(this.date.getMonth() + value);
    this.date.setDate(Math.min(n, this.getDaysInMonth()));
    return this.date;
}

DateClass.prototype.getDaysInMonth = function() {
    var month = this.date.getMonth();
    return [31, (this.isLeapYear() ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month];
}

DateClass.prototype.isLeapYear = function() {
    var y = this.date.getFullYear();
    return (((y % 4 === 0) && (y % 100 !== 0)) || (y % 400 === 0)); 
}
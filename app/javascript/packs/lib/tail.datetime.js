;(function(root, factory){
  if(typeof root.tail === "undefined"){
    root.tail = {};
  }
  root.tail.DateTime = root.tail.datetime = factory(root, root.document);

  // jQuery Support
  if(typeof jQuery !== "undefined"){
    jQuery.fn.DateTime = jQuery.fn.datetime = function(o){
      var r = [], i;
      this.each(function(){ if((i = tail.DateTime(this, o)) !== false){ r.push(i); } });
      return (r.length === 1)? r[0]: (r.length === 0)? false: r;
    };
  }
}(window, function(w, d){
  "use strict";
  d.forms.inputmode = true;

  // Internal Helper Methods
  function cHAS(el, name){
      return (el && "classList" in el)? el.classList.contains(name): false;
  }
  function cADD(el, name){
      return (el && "classList" in el)? el.classList.add(name): undefined;
  }
  function cREM(el, name){
      return (el && "classList" in el)? el.classList.remove(name): undefined;
  }
  function trigger(el, event, opt){
      if(CustomEvent && CustomEvent.name){
          var ev = new CustomEvent(event, opt);
      } else {
          var ev = d.createEvent("CustomEvent");
          ev.initCustomEvent(event, !!opt.bubbles, !!opt.cancelable, opt.detail);
      }
      return el.dispatchEvent(ev);
  }
  function clone(obj, rep){
      if(typeof Object.assign === "function"){
          return Object.assign({}, obj, rep || {});
      }
      var clone = Object.constructor();
      for(var key in obj){
          clone[key] = (key in rep)? rep[key]: obj[key];
      }
      return clone;
  }
  function create(tag, classes){
      var r = d.createElement(tag);
          r.className = (classes && classes.join)? classes.join(" "): classes || "";
      return r;
  }
  function first(str){
      return str.charAt(0).toUpperCase() + str.slice(1);
  }
  function parse(str, time, reset){
      var date = (str instanceof Date)? str: (str)? new Date(str): false;
      if(!(date instanceof Date) || isNaN(date.getDate())){
          return false;
      }
      (reset)? date.setHours(0, 0, 0, 0): date;
      return (time === true)? date.getTime(): date;
  }

  /*
   |  CONSTRUCTOR
   |  @sicne  0.4.11 [0.2.0]
   */
  var datetime = function(el, config){
      el = (typeof el == "string")? d.querySelectorAll(el): el;
      if(el instanceof NodeList || el instanceof HTMLCollection || el instanceof Array){
          for(var _r = [], l = el.length, i = 0; i < l; i++){
              _r.push(new datetime(el[i], config));
          }
          return (_r.length === 1)? _r[0]: ((_r.length === 0)? false: _r);
      }
      if(!(el instanceof Element)){
          return false;
      } else if(!(this instanceof datetime)){
          return new datetime(el, config);
      }

      // Check Element
      if(datetime.inst[el.getAttribute("data-tail-datetime")]){
          return datetime.inst[el.getAttribute("data-tail-datetime")];
      }
      if(el.getAttribute("data-datetime")){
          var test = JSON.parse(el.getAttribute("data-datetime").replace(/\'/g, '"'));
          if(test instanceof Object){
              config = clone(config, test);
          }
      }

      // Init Instance
      this.e = el;
      this.id = ++datetime.count;
      this.con = clone(datetime.defaults, config);
      datetime.inst["tail-" + this.id] = this;
      this.e.setAttribute("data-tail-datetime", "tail-" + this.id);
      return this.init();
  };
  datetime.version = "0.4.13";
  datetime.status = "beta";
  datetime.count = 0;
  datetime.inst = {};

  /*
   |  STORAGE :: DEFAULT OPTIONS
   */
  datetime.defaults = {
      animate: true,                  // [0.4.0]          Boolean
      classNames: false,              // [0.3.0]          Boolean, String, Array, null
      closeButton: true,              // [0.4.5]          Boolean
      dateFormat: "YYYY-mm-dd",       // [0.1.0]          String (PHP similar Date)
      dateStart: false,               // [0.4.0]          String, Date, Integer, False
      dateRanges: [],                 // [0.3.0]          Array
      dateBlacklist: true,            // [0.4.0]          Boolean
      dateEnd: false,                 // [0.4.0]          String, Date, Integer, False
      locale: "en",                   // [0.4.0]          String
      position: "bottom",             // [0.1.0]          String
      rtl: "auto",                    // [0.4.1]          String, Boolean
      startOpen: false,               // [0.3.0]          Boolean
      stayOpen: false,                // [0.3.0]          Boolean
      time12h: false,                 // [0.4.13][NEW]    Boolean
      timeFormat: "HH:ii:ss",         // [0.1.0]          String (PHP similar Date)
      timeHours: true,                // [0.4.13][UPD]    Integer, Boolean, null
      timeMinutes: true,              // [0.4.13][UPD]    Integer, Boolean, null
      timeSeconds: 0,                 // [0.4.13][UPD]    Integer, Boolean, null
      timeIncrement: true,            // [0.4.5]          Boolean
      timeStepHours: 1,               // [0.4.3]          Integer
      timeStepMinutes: 5,             // [0.4.3]          Integer
      timeStepSeconds: 5,             // [0.4.3]          Integer
      today: true,                    // [0.4.0]          Boolean
      tooltips: [],                   // [0.4.0]          Array
      viewDefault: "days",            // [0.4.0]          String
      viewDecades: true,              // [0.4.0]          Boolean
      viewYears: true,                // [0.4.0]          Boolean
      viewMonths: true,               // [0.4.0]          Boolean
      viewDays: true,                 // [0.4.0]          Boolean
      weekStart: 0                    // [0.1.0]          String, Integer
  };

  /*
   |  STORAGE :: STRINGS
   */
  datetime.strings = {
      en: {
          months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
          days:   ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
          shorts: ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"],
          time:   ["Hours", "Minutes", "Seconds"],
          header: ["Select a Month", "Select a Year", "Select a Decade", "Select a Time"]
      },
      modify: function(locale, id, string){
          if(!(locale in this)){
              return false;
          }
          if((id instanceof Object)){
              for(var key in id){
                  this.modify(locale, key, id[key]);
              }
          } else {
              this[locale][id] = (typeof string == "string")? string: this[locale][id];
          }
          return true;
      },
      register: function(locale, object){
          if(typeof locale != "string" || !(object instanceof Object)){
              return false;
          }
          this[locale] = object;
          return true;
      }
  };

  /*
   |  DATETIME HANDLER
   */
  datetime.prototype = {
      /*
       |  INTERNAL :: INIT CALENDAR
       |  @since  0.4.13 [0.2.0]
       */
      init: function(){
          var self = this.prepare();

          // Init Weekdays
          var week = this.__["shorts"].slice(this.con.weekStart).concat(this.__["shorts"].slice(0, this.con.weekStart));
          this.weekdays = "<thead>\n<tr>\n";
          for(var i = 0; i < 7; i++){
              this.weekdays += '<th class="calendar-week">' + week[i] + '</th>';
          }
          this.weekdays += "\n</tr>\n</thead>"

          // Init Select
          this.select = parse(this.e.getAttribute("data-value") || this.e.value);
          if(!this.select || this.select < this.con.dateStart || this.select > this.con.dateEnd){
              this.select = null;
          }

          // Init View
          if(this.view == undefined){
              this.view = {
                  type: this.con.viewDefault,
                  date: this.select || new Date()
              };
          }
          for(var l = ["Hours", "Minutes", "Seconds"], i = 0; i < 3; i++){
              if(typeof this.con["time" + l[i]] === "number"){
                  this.view.date["set" + l[i]](this.con["time" + l[i]]);
              } else {
                  while(this.view.date["get" + l[i]]() % this.con["timeStep" + l[i]] !== 0){
                      this.view.date["set" + l[i]](this.view.date["get" + l[i]]() + 1);
                  }
              }
          }
          this.ampm = this.view.date.getHours() > 12;

          // Init Mains
          this.events = {};
          this.dt = this.renderCalendar();

          // Store Instance and Return
          if(this.con.startOpen){
              this.open();
          }
          if(this.select){
              this.selectDate(this.select);
          }
          return this.bind();
      },

      /*
       |  INTERNAL :: PREPARE CALENDAR
       |  @since  0.4.13 [0.4.13]
       */
      prepare: function(){
          this.__ = clone(datetime.strings.en, datetime.strings[this.con.locale] || {});

          // Prepare Options
          this.con.dateStart = parse(this.con.dateStart, true, true) || -9999999999999;
          this.con.dateEnd = parse(this.con.dateEnd, true, true) || 9999999999999;
          this.con.viewDefault = (!this.con.dateFormat)? "time": this.con.viewDefault;

          // Prepare Week Start
          if(typeof this.con.weekStart === "string"){
              this.con.weekStart = datetime.strings.en.shorts.indexOf(this.con.weekStart);
          }
          if(this.con.weekStart < 0 && this.con.weekStart > 6){
              this.con.weekStart = 0;
          }

          // Prepare Date Ranges
          if(this.con.dateRanges.length > 0){
              for(var r = [], e = this.con.dateRanges, l = e.length, i = 0; i < l; i++){
                  if(!(e[i] instanceof Object) || (!e[i].start && !e[i].days)){
                      continue;
                  }

                  // Prepare Dates
                  if((e[i].start = parse(e[i].start || false, true, true)) === false){
                      e[i].start = e[i].end = Infinity;
                  } else {
                      if((e[i].end = parse(e[i].end || false, true, true)) === false){
                          e[i].end = e[i].start;
                      }
                      e[i].start = (e[i].start > e[i].end)? [e[i].end, e[i].end = e[i].start][0]: e[i].start;
                  }

                  // Prepare Days
                  e[i].days = ("days" in e[i])? e[i].days: true;
                  e[i].days = (typeof e[i].days !== "boolean")? (function(days){
                      for(var _r = [], _l = days.length, _i = 0; _i < _l; _i++){
                          if(typeof days[_i] == "string"){
                              days[_i] = datetime.strings.en.shorts.indexOf(days[_i]);
                          }
                          if(days[_i] >= 0 && days[_i] <= 6){ _r.push(days[_i]); }
                      }
                      return _r;
                  }((e[i].days instanceof Array)? e[i].days: [e[i].days])): [0, 1, 2, 3, 4, 5, 6];

                  // Append
                  r.push({start: e[i].start, end: e[i].end, days: e[i].days});
              }
              this.con.dateRanges = r;
          }

          // Preare Tooltips
          if(this.con.tooltips.length > 0){
              for(var r = [], t = this.con.tooltips, l = t.length, i = 0, s, e; i < l; i++){
                  if(!(t[i] instanceof Object) || !t[i].date){
                      continue;
                  }

                  // Prepare Dates
                  if(t[i].date instanceof Array){
                      s = parse(t[i].date[0] || false, true, true);
                      e = parse(t[i].date[1] || false, true, true) || s;
                  } else {
                      s = e = parse(t[i].date || false, true, true);
                  }
                  if(!s){ continue; }

                  // Append
                  r.push({
                      date: (s !== e)? [s, e]: s,
                      text: t[i].text || "Tooltip",
                      color: t[i].color || "inherit",
                      element: t[i].element || (function(tooltip){
                          tooltip.className = "calendar-tooltip";
                          tooltip.innerHTML = '<div class="tooltip-inner">' + t[i].text || "Tooltip" + '</div>';
                          return tooltip;
                      }(d.createElement("DIV")))
                  });
              }
              this.con.tooltips = r;
          }
          return this;
      },

      /*
       |  INTERNAL :: BIND CALENDAR
       |  @since  0.4.13 [0.4.0]
       */
      bind: function(){
          var self = this;

          // Bind Element
          if(typeof this._bind === "undefined"){
              this.e.addEventListener("focusin", function(event){
                  self.open.call(self);
              });
              this.e.addEventListener("keyup", function(event){
                  self.callback.call(self, event);
              });
              d.addEventListener("keyup", function(event){
                  if(self.dt.contains(event.target)){
                      self.callback.call(self, event);
                  }
              });
              d.addEventListener("click", function(event){
                  if(self.dt.contains(event.target)){
                      self.callback.call(self, event);
                  } else if(!self.e.contains(event.target) && cHAS(self.dt, "calendar-open")){
                      if(event.target != self.dt && event.target != self.e && !self.con.stayOpen){
                          self.close.call(self);
                      }
                  }
              });
              d.addEventListener("mouseover", function(event){
                  if(self.dt.contains(event.target)){
                      self.callback.call(self, event);
                  }
              });
              this._bind = true;
          }
          return this;
      },

      /*
       |  INTERNAL :: HANDLE CALLBACKs
       |  @since  0.4.13 [0.4.13]
       */
      callback: function(event){
          var self = event.target, a = "getAttribute", d = "data-action", v = "data-view",
          elem = self[a](d)? self: self.parentElement[a](d)? self.parentElement: self;

          // Bind HoverEvents
          var t = "data-tooltip", tip;
          if(event.type == "mouseover"){
              if((tip = self[a](t)? self: elem[a](t)? elem: false) !== false){
                  if(!this.dt.querySelector("#tooltip-" + tip[a](t) + "-" + tip[a](t + "-time"))){
                      this.showTooltip(tip[a](t), tip, tip[a](t + "-time"));
                  }
              } else if(this.dt.querySelector(".calendar-tooltip:not(.remove)")){
                  this.hideTooltip(this.dt.querySelector(".calendar-tooltip").id.slice(8));
              }
          }

          // Bind ClickEvents
          if(event.type == "click"){
              if(!elem || (event.buttons != 1 && (event.which || event.button) != 1)){
                  return;
              }
              if(elem.hasAttribute("data-disabled")){
                  return;
              }
              switch(elem[a](d)){
                  case "prev":    //@fallthrough
                  case "next":
                      return this.browseView(elem[a](d));

                  case "cancel":
                      if(!this.con.stayOpen){
                          this.close();
                      }
                      break;

                  case "submit":
                      if(!this.con.stayOpen){
                          this.close();
                      }
                      return this.selectDate(this.fetchDate(parseInt(elem[a]("data-date"))));

                  case "view":
                      this.switchDate(elem[a]("data-year") || null, elem[a]("data-month") || null, elem[a]("data-day") || null);
                      return this.switchView(elem[a](v));
              }
          }

          // Bind KeyEvents
          if(event.type == "keyup"){
              if(event.target.tagName != "INPUT" && event.target !== this.e){
                  if(/calendar-(static|close)/i.test(this.dt.className)){
                      return false;
                  }
              }
              if((event.keyCode || event.which) == 13){ // Enter || Return
                  this.selectDate(this.fetchDate(this.select));
                  event.stopPropagation();
                  if(!this.con.stayOpen){ this.close(); }
              }
              if((event.keyCode || event.which) == 27){ // ESC
                  if(!this.con.stayOpen){ this.close(); }
              }
          }
      },

      /*
       |  INTERNAL :: EVENT TRIGGER
       |  @since  0.4.0 [0.4.0]
       */
      trigger: function(event){
          var obj = {bubbles: false, cancelable: true, detail: {args: arguments, self: this}};
          if(event == "change"){
              trigger(this.e, "input", obj);
              trigger(this.e, "change", obj);
          }
          trigger(this.dt, "tail::" + event, obj);
          for(var l = (this.events[event] || []).length, i = 0; i < l; i++){
              this.events[event][i].cb.apply(this, (function(args, a, b){
                  for(var l = a.length, i = 0; i < l; ++i){
                      args[i-1] = a[i];
                  }
                  args[i] = b;
                  return args;
              }(new Array(arguments.length), arguments, this.events[event][i].args)));
          }
          return true;
      },

      /*
       |  HELPER :: CALCULATE POSITION
       |  @since  0.4.13 [0.3.1]
       */
      calcPosition: function(){
          var a = this.dt.style, b = w.getComputedStyle(this.dt),
              x = parseInt(b.marginLeft)+parseInt(b.marginRight),
              y = parseInt(b.marginTop) +parseInt(b.marginBottom),
              p = {
                  top:    this.e.getBoundingClientRect().top  + w.scrollY,
                  left:   this.e.getBoundingClientRect().left - w.scrollX,
                  width:  this.e.offsetWidth  || 0,
                  height: this.e.offsetHeight || 0
              };

          // Calc Position
          a.visibility = "hidden";
          switch(this.con.position){
              case "top":
                  var top = p.top - (this.dt.offsetHeight + y),
                      left = (p.left + (p.width / 2)) - (this.dt.offsetWidth / 2 + x / 2);
                  break;
              case "left":
                  var top = (p.top + p.height / 2) - (this.dt.offsetHeight / 2 + y),
                      left = p.left - (this.dt.offsetWidth + x);
                  break;
              case "right":
                  var top = (p.top + p.height / 2) - (this.dt.offsetHeight / 2 + y),
                      left = p.left + p.width;
                  break;
              default:
                  var top = p.top + p.height,
                      left = (p.left + (p.width / 2)) - (this.dt.offsetWidth / 2 + x / 2);
                  break;
          }

          // Set Position
          a.top = ((top >= 0)? top: this.e.offsetTop) + "px";
          a.left = ((left >= 0)? left: 0) + "px";
          a.visibility = "visible";
          return this;
      },

      /*
       |  HELPER :: CONVERT DATE
       |  @since  0.4.10 [0.1.0]
       */
      convertDate: function(inDate, format){
          var dateObject = {
              H: String("00" + inDate.getHours()).toString().slice(-2),
              G: function(hours){ return (hours % 12)? hours % 12: 12; }(inDate.getHours()),
              A: inDate.getHours() >= 12? "PM": "AM",
              a: inDate.getHours() >= 12? "pm": "am",
              i: String("00" + inDate.getMinutes()).toString().slice(-2),
              s: String("00" + inDate.getSeconds()).toString().slice(-2),
              Y: inDate.getFullYear(),
              y: parseInt(inDate.getFullYear().toString().slice(2)),
              m: String("00" + (inDate.getMonth() + 1)).toString().slice(-2),
              M: this.__["months"][inDate.getMonth()].slice(0, 3),
              F: this.__["months"][inDate.getMonth()],
              d: String("00" + inDate.getDate()).toString().slice(-2),
              D: this.__["days"][inDate.getDay()],
              l: this.__["shorts"][inDate.getDay()].toLowerCase()
          };
          return format.replace(/([HGismd]{1,2}|[Y]{2,4}|y{2})/g, function(token){
              if(token.length == 4 || token.length == 2){
                  return dateObject[token.slice(-1)].toString().slice(-Math.abs(token.length));
              } else if(token.length == 1 && token[0] == "0"){
                  return dateObject[token.slice(-1)].toString().slice(-1)
              }
              return dateObject[token.slice(-1)].toString();
          }).replace(/(A|a|M|F|D|l)/g, function(token){ return dateObject[token]; });
      },

      /*
       |  RENDER :: CALENDAR
       |  @since  0.4.13 [0.4.0]
       */
      renderCalendar: function(){
          var cls = ["tail-datetime-calendar", "calendar-close"],
              cus = (this.con.classNames === true)? this.e.className.split(" "): this.con.classNames;

          // Classes
          if(["top", "left", "right", "bottom"].indexOf(this.con.position) < 0){
              var sta = d.querySelector(this.con.position);
              cls.push("calendar-static");
          }
          if(this.con.rtl === true || ["ar", "he", "mdr", "sam", "syr"].indexOf(this.con.rtl) >= 0){
              cls.push("rtl");
          }
          if(this.con.stayOpen){
              cls.push("calendar-stay");
          }

          // Customs
          cus = (typeof cus.split === "function")? cus.split(" "): cus;
          if(cus instanceof Array){
              cls = cls.concat(cus);
          }

          // Create
          var dt = create("DIV", cls), ins = false;
          dt.id = "tail-datetime-" + this.id;

          // Render Actions
          if(this.con.dateFormat){
              ins = '<span class="action action-prev" data-action="prev"></span>'
                  + '<span class="label" data-action="view" data-view="up"></span>'
                  + '<span class="action action-next" data-action="next"></span>';
          } else if(this.con.timeFormat){
              ins = '<span class="action action-submit" data-action="submit"></span>'
                  + '<span class="label"></span>'
                  + '<span class="action action-cancel" data-action="cancel"></span>';
          }
          dt.innerHTML = (ins)? '<div class="calendar-actions">' + ins + '</div>': '';

          // Render Interfaces
          if(this.con.dateFormat){
              this.renderDatePicker(dt, this.con.viewDefault);
          }
          if(this.con.timeFormat){
              this.renderTimePicker(dt);
          }

          // Render Close
          if(this.con.closeButton && !sta){
              var close = create("BUTTON", "calendar-close"), self = this;
              close.addEventListener("click", function(event){
                  event.preventDefault();
                  self.close();
              });
              dt.appendChild(close);
          }

          // Append Calendar
          (sta || d.body).appendChild(dt);
          return dt;
      },

      /*
       |  RENDER :: DATE PICKER
       |  @since  0.4.0 [0.4.0]
       */
      renderDatePicker: function(dt, view){
          if(!view || ["decades", "years", "months", "days"].indexOf(view) < 0){
              view = this.con.viewDays? "days": this.con.viewMonths? "months":
                     this.con.viewYears? "years": this.con.viewDecades? "decades": false;
          }
          if(!view || !this.con["view" + first(view)] || !this.con.dateFormat){ return false; }

          // Render View
          var content = d.createElement("DIV");
              content.className = "calendar-datepicker calendar-view-" + view;
              content.innerHTML = this["view" + first(view)]();

          // Append Element
          if(dt.querySelector(".calendar-datepicker")){
              dt.replaceChild(content, dt.querySelector(".calendar-datepicker"));
          } else {
              dt.appendChild(content);
          }
          this.view.type = view;
          return this.handleLabel(dt);
      },

      /*
       |  RENDER :: TIME PICKER
       |  @since  0.4.13 [0.4.0]
       */
      renderTimePicker: function(dt){
          if(!this.con.timeFormat){
              return false;
          }
          var fields = [], input, i = 0;

          // AM | PM Switch
          if(this.con.time12h){
              var checked = (this.view.date.getHours() > 12)? 'checked="checked" ': '';
              fields.push(
                  '<label class="timepicker-switch" data-am="AM" data-pm="PM">' +
                      '<input type="checkbox" value="1" data-input="PM" ' + checked + '/><span></span>' +
                  '</label>'
              );
          }

          // Hours & Minutes & Seconds
          for(var key in { Hours: 0, Minutes: 0, Seconds: 0 }){
              if(this.con["time" + key] === false){
                  fields.push((i++)? null: null);
                  continue;
              }

              input = d.createElement("INPUT");
              input.type = "text";
              input.disabled = (this.con["time" + key] === null);
              input.setAttribute("min", (key === "Hours" && this.con.time12h)? "01": "00");
              input.setAttribute("max", (key !== "Hours")? "60": (this.con.time12h)? "13": "24");
              input.setAttribute("step", this.con["timeStep" + key]);
              input.setAttribute("value", function(n){ return (n < 10)? "0" + n: n; }(this.view.date["get" + key]()));
              input.setAttribute("pattern", "\d*");
              input.setAttribute("inputmode", "numeric");
              input.setAttribute("data-input", key.toLowerCase());

              fields.push(
                  '<div class="timepicker-field timepicker-' + key.toLowerCase() + '">' +
                      input.outerHTML +
                      '<button class="picker-step step-up"></button>' +
                      '<button class="picker-step step-down"></button>' +
                      '<label>' + this.__["time"][i++] + '</label>' +
                  '</div>'
              );
          }

          // Render View
          var div = create("DIV", "calendar-timepicker"), self = this;
          div.innerHTML = fields.join("\n");

          // Bind Input
          for(var inp = div.querySelectorAll("input"), i = 0; i < inp.length; i++){
              if(inp[i].type === "checkbox"){
                  inp[i].addEventListener("change", function(ev){
                      self.handleTime.call(self, this);
                  });
                  continue;
              }

              inp[i].addEventListener("input", function(ev){
                  self.handleTime.call(self, this);
              });
              inp[i].addEventListener("keydown", function(ev){
                  var key = event.keyCode || event.which || 0;
                  if(key === 38 || key === 40){
                      ev.preventDefault();
                      self.handleStep.call(self, this, (key === 38? "up": "down"));
                      return false;
                  }
              });
          }

          // Bind Buttons
          for(var inp = div.querySelectorAll("button"), i = 0; i < inp.length; i++){
              inp[i].addEventListener("mousedown", function(ev){
                  ev.preventDefault();

                  var input = this.parentElement.querySelector("input");
                  self.handleStep.call(self, input, cHAS(this, "step-up")? "up": "down");
                  return false;
              });
          }

          // Append Element
          var ct = dt.querySelector(".calendar-timepicker");
          dt[(ct)? "replaceChild": "appendChild"](div, ct);
          return this.handleLabel(dt);
      },

      /*
       |  HANDLE :: TIME FIELD
       |  @since  0.4.13 [0.4.5]
       */
      handleTime: function(input){
          if(this.con.time12h && input.type === "checkbox"){
              this.ampm = input.checked;
          }

          // Select Time
          var time = input.parentElement.parentElement;
              time = [
                  (time.querySelector("input[data-input=hours]")   || {value: 0}),
                  (time.querySelector("input[data-input=minutes]") || {value: 0}),
                  (time.querySelector("input[data-input=seconds]") || {value: 0})
              ];
          this.selectTime(
              parseInt(time[0].value) + (this.ampm? 12: 0),
              parseInt(time[1].value),
              parseInt(time[2].value)
          );

          // Handle Values
          time[2].value = this.view.date.getSeconds();
          time[1].value = this.view.date.getMinutes();
          if(this.con.time12h){
              time[0].value = (this.view.date.getHours() > 12)? this.view.date.getHours() - 12: this.view.date.getHours();
          } else {
              time[0].value = this.view.date.getHours();
          }
      },

      /*
       |  HANDLE :: TIME STEPs
       |  @since  0.4.13 [0.4.13]
       */
      handleStep: function(input, action, prevent){
          var inc = false;
          var name = input.getAttribute("data-input");
          var step = this.con["timeStep" + first(name)];
          var value = parseInt(input.value);
          var limit = (name !== "hours")? 60: (this.con.time12h)? 13: 24;

          // Calculate
          if(action === "up" && value + step >= limit){
              inc = this.con.timeIncrement && limit === 60;
              input.value = (limit === 13)? 1: 0;
              this.ampm = (this.view.date.getHours() + 1) >= 12;
          } else if(action === "down" && value - step < (limit === 13? 1: 0)){
              inc = this.con.timeIncrement && limit === 60;
              input.value = limit - step;
              this.ampm = (this.view.date.getHours() - 1) <= 0;
          } else {
              input.value = (action === "up")? value + step: value - step;
          }

          // Leading Zero
          if(input.value < 10){
              input.value = "0" + input.value;
          }

          // Increment
          if(inc){
              var prev = input.parentElement.previousElementSibling.querySelector("input");
              if(prev && prev.disabled === false){
                  this.handleStep(prev, action, true);
              }
          }

          // Set Time
          if(typeof prevent !== "undefined" && prevent === true){
              return false;
          }
          var time = input.parentElement.parentElement;
          this.selectTime(
              parseInt((time.querySelector("input[data-input=hours]")   || {value: 0}).value) + (this.ampm? 12: 0),
              parseInt((time.querySelector("input[data-input=minutes]") || {value: 0}).value),
              parseInt((time.querySelector("input[data-input=seconds]") || {value: 0}).value)
          );

          // Check AM/PM
          if(this.con.time12h){
              var ampm = input.parentElement.parentElement.querySelector("input[type=checkbox]");
              if(ampm && ampm.checked !== this.view.date.getHours() > 12){
                  ampm.checked = this.view.date.getHours() > 12;
              }
          }
          return true;
      },

      /*
       |  VIEW :: HANDLE LABEL
       |  @since  0.4.6 [0.4.0]
       */
      handleLabel: function(dt){
          var label = dt.querySelector(".label"), text, year;
          switch(this.view.type){
              case "days":
                  text = this.__["months"][this.view.date.getMonth()] + ", " + this.view.date.getFullYear();
                  break;

              case "months":
                  text = this.view.date.getFullYear();
                  break;

              case "years":
                  year = parseInt((this.view.date.getFullYear()).toString().slice(0, 3) + "0");
                  text = year + " - " + (year+10);
                  break;

              case "decades":
                  year = parseInt((this.view.date.getFullYear()).toString().slice(0, 2) + "00");
                  text = year + " - " + (year+100);
                  break;

              case "time":
                  text = this.__.header[3];
                  break;
          }
          label.innerText = text;
          return dt;
      },

      /*
       |  VIEW :: SHOW DECADEs
       |  @since  0.4.0 [0.4.0]
       */
      viewDecades: function(){
          var year = this.view.date.getFullYear(),
              date = new Date(this.view.date.getTime()),
              today = this.con.today? (new Date()).getYear(): 0;
              date.setFullYear(year-parseInt(year.toString()[3])-30);

          for(var c, a, t = [], r = [], i = 1; i <= 16; i++){
              c = 'calendar-decade' + (today >= date.getYear() && today <= (date.getYear()+10)? ' date-today': '');
              a = 'data-action="view" data-view="down" data-year="' + date.getFullYear() + '"';
              t.push('<td class="' + c + '" ' + a + '><span class="inner">' + date.getFullYear() + " - " + (date.getFullYear()+10) + '</span></td>');

              if(i >= 4 && i%4 == 0){
                  r.push("<tr>\n" + t.join("\n") + "\n</tr>"); t = [];
              }
              date.setFullYear(date.getFullYear() + 10);
          }
          return '<table class="calendar-decades">'
               + '<thead><tr><th colspan="4">' + this.__["header"][2] + '</th></tr></thead>'
               + '<tbody>' + r.join("\n") + '</tbody></table>';
      },

      /*
       |  VIEW :: SHOW YEARs
       |  @since  0.4.0 [0.4.0]
       */
      viewYears: function(){
          var year = this.view.date.getFullYear(),
              date = new Date(this.view.date.getTime()),
              today = this.con.today? (new Date()).getYear(): 0;
              date.setFullYear(year-parseInt(year.toString()[3])-2);

          for(var c, a, t = [], r = [], i = 1; i <= 16; i++){
              c = 'calendar-year' + ((date.getYear() == today)? ' date-today': '');
              a = 'data-action="view" data-view="down" data-year="' + date.getFullYear() + '"';
              t.push('<td class="' + c + '" ' + a + '><span class="inner">' + date.getFullYear() + '</span></td>');

              if(i >= 4 && i%4 == 0){
                  r.push("<tr>\n" + t.join("\n") + "\n</tr>"); t = [];
              }
              date.setFullYear(date.getFullYear() + 1);
          }
          return '<table class="calendar-years">'
               + '<thead><tr><th colspan="4">' + this.__["header"][1] + '</th></tr></thead>'
               + '<tbody>' + r.join("\n") + '</tbody></table>';
      },

      /*
       |  VIEW :: SHOW MONTHs
       |  @since  0.4.0 [0.4.0]
       */
      viewMonths: function(){
          var strings = this.__["months"], today = this.con.today? (new Date()).getMonth(): -1;
              today = (this.view.date.getYear() == (new Date()).getYear())? today: -1;

          for(var c, a, t = [], r = [], i = 0; i < 12; i++){
              c = 'calendar-month' + ((today == i)? ' date-today': '');
              a = 'data-action="view" data-view="down" data-month="' + i + '"';
              t.push('<td class="' + c + '" ' + a + '><span class="inner">' + strings[i] + '</span></td>');

              if(t.length == 3){
                  r.push("<tr>\n" + t.join("\n") + "\n</tr>"); t = [];
              }
          }
          return '<table class="calendar-months">'
               + '<thead><tr><th colspan="3">' + this.__["header"][0] + '</th></tr></thead>'
               + '<tbody>' + r.join("\n") + '</tbody></table>';
      },

      /*
       |  VIEW :: SHOW DAYs
       |  @since  0.4.1 [0.4.0]
       */
      viewDays: function(){
          var date = new Date(this.view.date.getTime()), time,
              today = new Date().toDateString(),
              month = date.getMonth(), c, a, t = [], r = [], i,
              disabled = [0, []], check, ranges = [].concat(this.con.dateRanges),
              tooltips = [].concat(this.con.tooltips), tooltip = [0, 0];

          // Reset Date
          date.setHours(0, 0, 0, 0);
          date.setDate(1);
          date.setDate((1 - (date.getDay() - this.con.weekStart)));

          // Create Table
          while(r.length < 6){
              time = date.getTime();

              // Attributes and ClassNames
              a = 'data-action="submit" data-date="' + date.getTime() + '"';
              c = 'calendar-day date-' + ((date.getMonth() > month)? 'next':
                  (date.getMonth() < month)? 'previous': 'current');
              if(this.con.today && today == date.toDateString()){
                  c += ' date-today';
              }

              // Calc Disabled
              if(this.con.dateBlacklist && ((time) < this.con.dateStart || time > this.con.dateEnd)){
                  disabled = [(time < this.con.dateStart)? this.con.dateStart: Infinity, [0, 1, 2, 3, 4, 5, 6], true];
              } else if(disabled[0] == 0){
                  ranges = ranges.filter(function(obj){
                      if(obj.start == Infinity || (time >= obj.start && time <= obj.end)){
                          disabled = [obj.end, obj.days];
                          return false;
                      }
                      return obj.start > time;
                  }, this);
              } else if(disabled.length == 3){
                  disabled = [0, [0, 1, 2, 3, 4, 5, 6]];
              }

              // Calc Tooltips
              if(this.con.tooltips.length > 0){
                  tooltips = this.con.tooltips.filter(function(obj, index){
                      if(obj.date instanceof Array){
                          if(obj.date[0] <= time && obj.date[1] >= time){
                              tooltip = [obj.date[1], index, obj.color];
                          }
                      } else if(obj.date == time){
                          tooltip = [obj.date, index, obj.color]
                      }
                  }, this);
              }
              if(tooltip[0] < time){
                  tooltip = [0, 0];
              }

              // Disabled
              check = disabled[0] >= time && disabled[1].indexOf(date.getDay()) >= 0;
              if((check && this.con.dateBlacklist) || (!check && !this.con.dateBlacklist)){
                  c += ' date-disabled';
                  a += ' data-disabled="true"';
              } else if(disabled[0] !== 0 && disabled[0] <= time){
                  disabled = [0, []];
              }

              // Curent
              if(this.select && this.select.toDateString() == date.toDateString()){
                  c += ' date-select';
              }

              // Create Calendar Item
              i = '<span class="inner">' + date.getDate() + '</span>';
              if(tooltip[0] > 0){
                  c += ' date-tooltip';
                  a += ' data-tooltip="' + tooltip[1] + '" data-tooltip-time="' + time + '"';
                  if(tooltip[2] !== "inherit"){
                      i += '<span class="tooltip-tick" style="background:' + tooltip[2] + ';"></span>';
                  } else {
                      i += '<span class="tooltip-tick"></span>';
                  }
              }
              t.push('<td class="' + c + '" ' + a + '>' + i + '</td>')

              // Next
              if(t.length == 7){
                  r.push("<tr>\n" + t.join("\n") + "\n</tr>"); t = [];
              }
              date.setDate(date.getDate()+1);
          }
          r = "<tbody>" + r.join("\n") + "</tbody>";

          // Create Table Header
          return '<table class="calendar-days">' + this.weekdays + r + '</table>';
      },

      /*
       |  VIEW :: SHOW TOOLTIP
       |  @since  0.4.0 [0.4.0]
       */
      showTooltip: function(id, field, time){
          var t = this.con.tooltips[id].element, e = t.style, w, h,
              d = this.dt.querySelector(".calendar-datepicker");

          // Calc Tooltip Rect
          e.cssText = "opacity:0;visibility:hidden;";
          t.id = "tooltip-" + id + "-" + time;
          d.appendChild(t);
          w = t.offsetWidth; h = t.offsetHeight;

          // Set Tooltip Rect
          e.top = field.offsetTop + field.offsetHeight + "px";
          e.left = (field.offsetLeft + (field.offsetWidth/2)) - (w/2) + "px"
          e.visibility = "visible";

          // Animate Tooltip
          if(this.con.animate){
              t.setAttribute("data-top", parseInt(e.top));
              e.top = (parseInt(e.top) + 5) + "px";
              (function fade(){
                  if(parseFloat(e.top) > t.getAttribute("data-top")){
                      e.top = (parseFloat(e.top) - 0.5) + "px";
                  }
                  if((e.opacity = parseFloat(e.opacity)+0.125) < 1){
                      setTimeout(fade, 20);
                  }
              })();
          } else {
              e.opacity = 1;
          }
      },

      /*
       |  VIEW :: HIDE TOOLTIP
       |  @since  0.4.0 [0.4.0]
       */
      hideTooltip: function(id){
          var t = this.dt.querySelector("#tooltip-" + id), e = t.style;

          // Animate Tooltip
          if(this.con.animate){
              t.className += " remove";
              (function fade(){
                  if(parseFloat(e.top) < (parseInt(t.getAttribute("data-top"))+5)){
                      e.top = (parseFloat(e.top) + 0.5) + "px";
                  }
                  if((e.opacity -= 0.125) < 0){
                      return (t.className = "calendar-tooltip")? t.parentElement.removeChild(t): "";
                  }
                  setTimeout(fade, 20);
              })();
          } else {
              t.parentElement.removeChild(t);
          }
      },

      /*
       |  PUBLIC :: SWITCH VIEW
       |  @since  0.4.1 [0.1.0]
       */
      switchView: function(view){
          var order = [null, "days", "months", "years", "decades", null];
          if(order.indexOf(view) == -1){
              if(view == "up"){
                  view = order[(order.indexOf(this.view.type) || 5)+1] || null;
              } else if(view == "down"){
                  view = order[(order.indexOf(this.view.type) || 1)-1] || null;
              }
              if(!(view && this.con["view" + first(view)])){
                  view = false;
              }
          }
          if(!view){
              return false;
          }
          this.renderDatePicker(this.dt, view);
          return this.trigger("view", view);
      },

      /*
       |  PUBLIC :: SWITCH DATE
       |  @since  0.4.1 [0.4.0]
       */
      switchDate: function(year, month, day, none){
          this.view.date.setFullYear((year == undefined)? this.view.date.getFullYear(): year);
          this.view.date.setMonth((month == undefined)? this.view.date.getMonth(): month);
          if(day == "auto"){
              var test = this.view.date, now = new Date();
              if(test.getMonth() == now.getMonth() && test.getYear() == now.getYear()){
                  day = now.getDate();
              } else {
                  day = 1;
              }
          }
          this.view.date.setDate(day || this.view.date.getDate());
          return (none === true)? true: this.switchView(this.view.type);
      },

      /*
       |  PUBLIC :: SWITCH MONTH
       |  @since  0.4.0 [0.1.0]
       */
      switchMonth: function(month, year){
          if(typeof month == "string"){
              month = ["previous", "prev"].indexOf(month) >= 0? -1: 1;
              month = this.view.date.getMonth() + type;
          }
          return this.switchDate(year || this.getFullYear(), month);
      },

      /*
       |  PUBLIC :: SWITCH YEAR
       |  @since  0.4.0 [0.1.0]
       */
      switchYear: function(year){
          if(typeof year == "string"){
              year = ["previous", "prev"].indexOf(year) >= 0? -1: 1;
              year = this.view.date.getFullYear() + type;
          }
          return this.switchDate(year);
      },

      /*
       |  PUBLIC :: BROWSE VIEW
       |  @since  0.4.0 [0.4.0]
       */
      browseView: function(type){
          type = (["previous", "prev"].indexOf(type) >= 0)? -1: 1;
          switch(this.view.type){
              case "days":
                  return this.switchDate(null, this.view.date.getMonth() + type, "auto");
              case "months":
                  return this.switchDate(this.view.date.getFullYear() + type, null, "auto");
              case "years":
                  return this.switchDate(this.view.date.getFullYear() + (type*10), null, "auto");
              case "decades":
                  return this.switchDate(this.view.date.getFullYear() + (type*100), null, "auto");
          }
          return false;
      },

      /*
       |  PUBLIC :: FETCH DATE / DTIME
       |  @since  0.4.0 [0.4.0]
       */
      fetchDate: function(date){
          date = parse(date || false) || this.view.date;
          var inp = this.dt.querySelectorAll("input[type=number]");
          if(inp && inp.length == 3){
              date.setHours(inp[0].value || 0, inp[1].value || 0, inp[2].value || 0, 0);
          }
          return date;
      },

      /*
       |  PUBLIC :: SELECT DATE / TIME
       |  @since  0.4.2 [0.1.0]
       */
      selectDate: function(Y, M, D, H, I, S){
          var n = new Date(), f = [];
          (this.con.dateFormat)? f.push(this.con.dateFormat): null;
          (this.con.timeFormat)? f.push(this.con.timeFormat): null;

          // Set Value
          this.select = (Y instanceof Date)? Y: new Date(
              Y? Y: (Y == undefined)? this.view.date.getFullYear(): n.getFullYear(),
              M? M: (M == undefined)? this.view.date.getMonth():    n.getMonth(),
              D? D: (D == undefined)? this.view.date.getDate():     n.getDate(),
              H? H: (H == undefined)? this.view.date.getHours():    0,
              I? I: (I == undefined)? this.view.date.getMinutes():  0,
              S? S: (S == undefined)? this.view.date.getSeconds():  0
          );
          this.view.date = new Date(this.select.getTime());

          this.e.value = this.convertDate(this.select, f.join(" "));
          this.e.setAttribute("data-value", this.select.getTime());
          this.switchView("days");
          return this.trigger("change");
      },
      selectTime: function(H, I, S){
          return this.selectDate(undefined, undefined, undefined, H, I, S);
      },

      /*
       |  PUBLIC :: OPEN CALENDAR
       |  @since  0.4.13 [0.1.0]
       */
      open: function(){
          if(!cHAS(this.dt, "calendar-close")){
              return this;
          }
          var self = this, e = this.dt.style;

          // Animate
          e.display = "block";
          e.opacity = (this.con.animate)? 0: 1;
          cREM(this.dt, "calendar-close");
          cADD(this.dt, "calendar-idle");
          if(!cHAS(this.dt, "calendar-static")){
              self.calcPosition();
          }
          (function fade(){
              if((e.opacity = parseFloat(e.opacity)+0.125) >= 1){
                  cREM(self.dt, "calendar-idle");
                  cADD(self.dt, "calendar-open");
                  return self.trigger("open");
              }
              setTimeout(fade, 20);
          })();
          return this;
      },

      /*
       |  PUBLIC :: CLOSE CALENDAR
       |  @since  0.4.13 [0.1.0]
       */
      close: function(){
          if(!cHAS(this.dt, "calendar-open")){
              return this;
          }
          var self = this, e = this.dt.style;

          // Animate
          e.display = "block";
          e.opacity = (this.con.animate)? 1: 0;
          cREM(this.dt, "calendar-open");
          cADD(this.dt, "calendar-idle");
          (function fade(){
              if((e.opacity -= 0.125) <= 0){
                  cREM(self.dt, "calendar-idle");
                  cADD(self.dt, "calendar-close");
                  e.display = "none";
                  return self.trigger("close");
              }
              setTimeout(fade, 20);
          })();
          return this;
      },

      /*
       |  PUBLIC :: CLOSE CALENDAR
       |  @since  0.4.0 [0.1.0]
       */
      toggle: function(){
          if(cHAS(this.dt, "calendar-open")){
              return this.close();
          }
          return cHAS(this.dt, "calendar-close")? this.open(): this;
      },

      /*
       |  PUBLIC :: ADD EVENT LISTENER
       |  @since  0.4.0 [0.3.0]
       */
      on: function(event, func, args){
          var events = ["open", "close", "change", "view"];
          if(events.indexOf(event) < 0 || typeof func != "function"){
              return false;
          }
          if(!(event in this.events)){
              this.events[event] = [];
          }
          this.events[event].push({cb: func, args: (args instanceof Array)? args: []});
          return this;
      },

      /*
       |  PUBLIC :: REMOVE CALENDAR
       |  @since  0.4.0 [0.3.0]
       */
      remove: function(){
          this.e.removeAttribute("data-tail-datetime");
          this.e.removeAttribute("data-value");
          this.dt.parentElement.removeChild(this.dt);
          return this;
      },

      /*
       |  PUBLIC :: REMOVE CALENDAR
       |  @since  0.4.0 [0.3.3]
       */
      reload: function(){
          this.remove();
          return this.init();
      },

      /*
       |  PUBLIC :: (G|S)ET OPOTION
       |  @since  0.4.0 [0.4.0]
       */
      config: function(key, value, rebuild){
          if(key instanceof Object){
              for(var k in key){
                  this.config(k, key[k], false);
              }
              this.reload();
              return this.con;
          }
          if(typeof key == "undefined"){
              return this.con;
          } else if(!(key in this.con)){
              return false;
          }

          // Set | Return
          if(typeof value == "undefined"){
              return this.con[key];
          }
          this.con[key] = value;
          if(this.rebuild !== false){
              this.reload();
          }
          return this;
      }
  };

  // Return
  return datetime;
}));
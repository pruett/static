module.exports = (kitId) ->
  """
  /* Typekit */
  (function(d) {
    var config = {
      kitId:'#{kitId}',
      events:false,classes:false,async:true,scriptTimeout:3000
    },
    h=d.documentElement,t=setTimeout(function(){h.className=
    h.className.replace(/\bwf-loading\b/g,"")+" wf-inactive";},
    config.scriptTimeout),tk=d.createElement("script"),f=false,s=
    d.getElementsByTagName("script")[0],a;h.className+=" wf-loading";
    tk.src='//fonts.warbycdn.com/'+config.kitId+'.js';tk.async=true;
    tk.onload=tk.onreadystatechange=function(){a=this.readyState;
    if(f||a&&a!="complete"&&a!="loaded")return;f=true;clearTimeout(t);
    try{Typekit.load(config)}catch(e){}};s.parentNode.insertBefore(tk,s)
  })(document);
  """

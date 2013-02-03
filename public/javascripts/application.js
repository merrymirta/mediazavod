function addBookmark(url, title)
{
if (!url) url = location.href;
if (!title) title = document.title;
//Gecko
if ((typeof window.sidebar == "object") && (typeof window.sidebar.addPanel == "function")) window.sidebar.addPanel (title, url, "");
//IE4+
else if (typeof window.external == "object") window.external.AddFavorite(url, title);
//Opera7+
else if (window.opera && document.createElement)
{
var a = document.createElement('A');
if (!a) return false; //IF Opera 6
a.setAttribute('rel','sidebar');
a.setAttribute('href',url);
a.setAttribute('title',title);
a.click();
}
else return false;
return true;
}

function services_show(){
  document.getElementById('services').className='over';
}
function services_hide(){
  document.getElementById('services').className='';
}

jQuery(document).ready(function(){
  jQuery('#main_subscription').hover(
    function(){
      jQuery('#main_subscription ul').removeClass('hidden');
    },
    function(){
      jQuery('#main_subscription ul').addClass('hidden');
    }
  );
})
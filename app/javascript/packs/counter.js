document.addEventListener('turbolinks:load', () => {
  if (document.getElementById('textarea') !==  null) { 
    let textarea = document.getElementById('textarea');
    let maxLength = textarea.maxLength;
    let currentLength = textarea.value.length;
    remainingLength = maxLength - currentLength;
    let message = document.getElementById('message');
    message.innerHTML = `${maxLength - currentLength}/${maxLength}文字`;

    textarea.addEventListener('keyup', function(){
      let currentLength = textarea.value.length
      message.innerHTML = `${maxLength - currentLength}/${maxLength}文字`
   }) 
  }
})
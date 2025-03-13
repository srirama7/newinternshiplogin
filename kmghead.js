        function togglePassword() {
        const passwordField = document.getElementById('password');
        const toggleBtn = document.querySelector('.toggle-password');
        
        if (passwordField.type === 'password') {
            passwordField.type = 'text';
            toggleBtn.textContent = 'Hide';
        } else {
            passwordField.type = 'password';
            toggleBtn.textContent = 'Show';
        }
    }
        document.getElementById('studentAccountForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Display credentials
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            
            document.getElementById('displayUsername').textContent = username;
            document.getElementById('displayPassword').textContent = password;
            
            document.getElementById('credentialsDisplay').classList.add('show');
        });
        
        document.addEventListener("DOMContentLoaded", function () {
    // Set default active form and button on page load
    showForm('studentdetails');
});

function showForm(formId) {
    // Hide all forms
    document.querySelectorAll('.form-container').forEach(form => {
        form.classList.remove('active');
    });

    // Deactivate all buttons
    document.querySelectorAll('.button-container button').forEach(button => {
        button.classList.remove('active');
    });

    // Show selected form
    document.getElementById(formId).classList.add('active');

    // Activate corresponding button
    if (formId === 'studentdetails') {
        document.getElementById('studentBtn').classList.add('active');
    } else if (formId === 'streamdetails') {
        document.getElementById('streamBtn').classList.add('active');
    } else if (formId === 'coursedetails') {
        document.getElementById('courseBtn').classList.add('active');
    }
}

    function fetchRole() {
        const emailSelect = document.getElementById('email');
        const roleInput = document.getElementById('role');
        
        if (emailSelect.value) {
            const selectedOption = emailSelect.options[emailSelect.selectedIndex];
            const internId = selectedOption.getAttribute('data-id');
            roleInput.value = 'cdot' + internId;
        } else {
            roleInput.value = '';
        }
    }
    
    document.getElementById('studentAccountForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Here you would typically send the form data to the server via AJAX
        // For demonstration, we'll just show the credentials
        const emailSelect = document.getElementById('email');
        const email = emailSelect.value;
        const role = document.getElementById('role').value;
        const password = document.getElementById('password').value;
        
        document.getElementById('displayEmail').textContent = email;
        document.getElementById('displayRole').textContent = role;
        document.getElementById('displayPassword').textContent = password;
        
        document.getElementById('credentialsDisplay').style.display = 'block';
    });
    
    function fetchEmail() {
    var cdotDropdown = document.getElementById("cdotId");
    var selectedOption = cdotDropdown.options[cdotDropdown.selectedIndex];
    var emailField = document.getElementById("email");

    if (selectedOption.value) {
        emailField.value = selectedOption.getAttribute("data-email");
    } else {
        emailField.value = "";
    }
}
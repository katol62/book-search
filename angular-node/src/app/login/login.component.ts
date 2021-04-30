import {Component, OnInit} from '@angular/core';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import {AuthService} from '../shared/services/auth.service';
import {Router} from '@angular/router';
import {IAuthRequest} from '../../../server/interfaces/http-data';
import {dashboardPath} from '../routes';
import {IMessageItem, NotificationMessageType, NotificationService} from '../shared/services/notification.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

  public loginForm: FormGroup;
  public error: string;

  constructor(private formBuilder: FormBuilder,
              private authService: AuthService,
              private notificationService: NotificationService,
              private router: Router) {
    this.loginForm = this.formBuilder.group({
      login: ['', Validators.compose([Validators.required, Validators.email])],
      password: ['', Validators.compose([Validators.required, Validators.minLength(3)])]
    });

  }

  ngOnInit(): void {
  }

  onSignIn() {
    if (!this.loginForm.valid) {
      return;
    }
    this.error = null;

    const authData: IAuthRequest = {email: this.loginForm.get('login').value, password: this.loginForm.get('password').value};

    this.authService.login(authData)
      .subscribe({
        next: value => {
          this.afterSignIn();
        },
        error: error => {
          // this.error = error.error.message;
          console.log(error);
        }
      });
  }

  private afterSignIn() {
    this.router.navigate([dashboardPath]);
  }

  get email() {
    return this.loginForm.get('login');
  }
  get password() {
    return this.loginForm.get('password');
  }
}

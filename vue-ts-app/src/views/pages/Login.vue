<template>
    <div class="container-fluid h-100">
        <div class="row justify-content-center align-content-center">
            <div class="col-12 justify-content-center align-content-center">
                <b-card
                        title="Login"
                        class="mb-4"
                >
                    <b-card-body>
                        <b-form @submit="onSubmit" @reset="onReset">
                            <b-form-group
                                    id="email-group"
                                    label="Email address:"
                                    label-for="email"
                                    description="Required"
                            >
                                <b-form-input
                                        id="email"
                                        v-model="form.email"
                                        type="email"
                                        required
                                        placeholder="Enter email"
                                ></b-form-input>
                            </b-form-group>
                            <b-form-group
                                    id="password-group"
                                    label="Password:"
                                    label-for="password"
                                    description="Required"
                            >
                                <b-form-input
                                        id="password"
                                        v-model="form.password"
                                        type="password"
                                        required
                                        placeholder="Enter password"
                                ></b-form-input>
                            </b-form-group>
                            <b-button type="submit" variant="primary">Submit</b-button>
                            <b-button type="reset" variant="danger">Reset</b-button>
                        </b-form>
                    </b-card-body>

                </b-card>
            </div>
        </div>
    </div>
</template>

<script lang="ts">
    import { Component, Prop, Vue } from 'vue-property-decorator';
    import AuthService from '@/services/AuthService';

    @Component
    export default class Login extends Vue {

        protected authService = AuthService.instance;

        public form = {
            email: '',
            password: '',
        };

        public onSubmit(evt: Event): void {
            evt.preventDefault();
            this.authService.login(this.form.email, this.form.password);
        }

        public onReset(evt: Event): void {
            this.form.email = '';
            this.form.password = '';
        }


    }
</script>

<style scoped>

</style>

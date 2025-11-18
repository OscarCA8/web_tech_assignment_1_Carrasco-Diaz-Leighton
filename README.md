# Members:

Oscar Carrasco Alvarez

Cristóbal Diaz Barra

Nicolas Leighton Encina

### Test accounts (seeded)
- Admin: `admin@example.com` / `password123`
- Regular user: `user@example.com` / `password123`

### Devise features enabled
- Sign up, login, logout, password recovery, account edit

### Abilities (CanCanCan)
- Admin: manage all
- Regular user: read challenges & badges, create/modify their own participations and progress entries, edit their user account.

### Reset DB / Seed
To reset DB (drops + creates + migrates + seeds):
```bash
bin/rails db:reset
```

To (re)seed data:
```bash
bin/rails db:seed
```



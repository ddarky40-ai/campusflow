const jsonServer = require('json-server');
const jwt = require('jsonwebtoken');

const server = jsonServer.create();
const router = jsonServer.router('db.json');
const middlewares = jsonServer.defaults();

const SECRET = process.env.JWT_SECRET || 'campusflow-secret-tp-local';

server.use(middlewares);
server.use(jsonServer.bodyParser);

server.post('/login', (req, res) => {
  const { email, password } = req.body;

  const user = router.db.get('users')
    .find({ email, password })
    .value();

  if (!user) {
    return res.status(401).json({
      message: 'Email ou mot de passe incorrect'
    });
  }

  const token = jwt.sign(
    {
      id: user.id,
      email: user.email
    },
    SECRET,
    { expiresIn: '2h' }
  );

  return res.json({
    token,
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      institution: user.institution,
      program: user.program
    }
  });
});

server.post('/register', (req, res) => {
  const { name, email, institution, program, password } = req.body;

  if (!name || !email || !institution || !program || !password) {
    return res.status(400).json({
      message: 'Tous les champs obligatoires doivent être renseignés'
    });
  }

  const existingUser = router.db.get('users')
    .find({ email })
    .value();

  if (existingUser) {
    return res.status(409).json({
      message: 'Un compte existe déjà avec cette adresse e-mail'
    });
  }

  const users = router.db.get('users').value();
  const id = String(
    users.reduce((maximum, user) => {
      const current = Number.parseInt(user.id, 10);
      return Number.isNaN(current) ? maximum : Math.max(maximum, current);
    }, 0) + 1
  );

  const user = {
    id,
    email,
    password,
    name,
    institution,
    program
  };

  router.db.get('users').push(user).write();

  const token = jwt.sign(
    { id: user.id, email: user.email },
    SECRET,
    { expiresIn: '2h' }
  );

  return res.status(201).json({
    token,
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      institution: user.institution,
      program: user.program
    }
  });
});

server.use((req, res, next) => {
  if (!req.path.startsWith('/tasks') && !req.path.startsWith('/courses')) {
    return next();
  }

  const authorization = req.headers.authorization;

  if (!authorization || !authorization.startsWith('Bearer ')) {
    return res.status(401).json({
      message: 'Authentification requise'
    });
  }

  const token = authorization.split(' ')[1];

  try {
    req.user = jwt.verify(token, SECRET);
    next();
  } catch (error) {
    return res.status(401).json({
      message: 'Token invalide ou expiré'
    });
  }
});

server.use(router);

server.listen(3000, '0.0.0.0', () => {
  console.log('CampusFlow API sécurisée démarrée sur le port 3000');
});

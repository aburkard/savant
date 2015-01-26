from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine

Base = automap_base()

engine = create_engine('mysql://root@localhost/CollegeHoops')

Base.prepare(engine, reflect=True)

Coach = Base.classes.Coach

session = Session(engine)

session.add(Coach(idCoach='coach1', first_name='Larry'))

session.commit()
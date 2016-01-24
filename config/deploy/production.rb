role :app, %w{web3.mydevil.net}
role :web, %w{web3.mydevil.net}
role :db,  %w{web3.mydevil.net}
server 'web3.mydevil.net', user: 'Vakrim', roles: %w{web app db}
set :rails_env, :production
set :deploy_to, '/home/Vakrim/domains/common-table.vakrim.usermd.net'

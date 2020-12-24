# dealcircles_flutter

##Web

`flutter build web`
`flutter run -d chrome`

###Deployment

aws s3 rm s3://dealcircles.com --recursive
aws s3 cp build/web/ s3://dealcircles.com --recursive

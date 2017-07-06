ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.9.2
docker tag hyperledger/composer-playground:0.9.2 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
�  d^Y �=ks�Ȗ���{gu+{o�����~�QR�d2�$$0�xjL�����I���I��|����������[���X<l�vpf©�1�>�}�q}t��i(]h��g6��<l[��7�Þ��a�A���o4�1��8�៰Q���1��O6e�O �@��
��� OK���x���Ї���.��)ʆV_U��KQ �k��E��tGVuh��r�sI�ړ�(�34���fZ�Q~`ITӰ۫���av�]��m���jz��)U*�*R�,U*fr�]����/ �&lɮ�]���:uh-U��.�;ZKnX�B�,�L��7X'���Ayx$n�ݧ�V,��M`���R��03[�A�~�}v6��uY�8�E�"��#	��^�`��*k��6�4\Ue��\�jB-��n*̌)�Z&�m��n$���gjӴg��)z5��a��#��"���6J����f.�1KV�-Tg1y�\^��qѯ�a�0M??S_`�)3�ݫrL��([�W�N��6���K���!��>Z��]bΨ�r�&9.� Wb�CD��쩄���j�"�g�Va�怾�,�����au�T�'{��-]�F�hR����c����7�&쇰�GK1��m`%�7�#��1<JgyV`� ��)�_���3����1�=�;�m�̿p����矍
,�114�q��o�u���"U�4d�Cنk)��_ �I�4U�<��cR��UJ�rJz�|���K|�=0M�+r�2��h�����s��>��G�v��[l��ˆ9�o�Jm��綡?H������aY!F�2����>���k���_g�bѾ��0a&,x�Ӿ����f� xd0����c@֛��Z���]}�&v� ��v��Zx��`Zj_v0���B�$�Nǰ��*��*P�I�D��;0�y]8D���n�Nj��U:2�5z�I�bh.�����PG�VE8�F���!ESݸ9ԝ0�5�#�G;�1��X؅��-��+�0q���3�s�醫j͐l)�OH�ۮf�P��~,��k' F��tznw0&i<N\S�SC�K��b���Y�e��sS9�2<�,i�����n�����&_�k.��8�K�?��cQ�	鄍�_�?��Vh�:q��#;��j��}�!�\]W���G���|��HQ����M���i�Я/)��ak�E�w{����׸JI�t@��p�2jv��﹟A-؈�jv�y-:I�TKE�s����ֹ[/�N��_�Y�H� ���^�Q̌���Jb������B���h���q[L�W�6�ULq�`��Rø����11/t��e�iu�FR�o�%��ʂ8�ZA��ɀ��G��Obs0�8w�c��Q��ꢨ�#WuH!L{�@?�N��CV�{��ejPq���*`��h��i� �|�`C�ur��Ӹ1�%�W4ԁ��i�+x��8�FDx_�p��	��=��K�N�hXP�~}�8����׳i^���mY���7��K�9�/���`X����F��6��/����\>P����c������m�-��I�k��g�y.�A��6m�as�24���n֒���Z�Id�֐J��{w'Tu?W9��ʹ���ߐl�~1���oٕ������mL1�C���͈�r.uV�ʕ\������l���	����m����t������#��d�=?@���o�Ո���'��x�2Ko�*��g�\A*ժ7S=�6�vV /l�&�i����D�=V����B�m��J|x��De!��ށ�s��;xnA��oI�qy#����Lq�n�-��=������e�,���N �ÊZ~Wt�q�-BO/�BO�"��Qbs係v���ȸ�h���?����_l�/���d�y��"������/�3�_<<�S��j�=��Pu4!�B!ӂ-���8�xL���7R��0�������z�g��E7����w8L8v�u�H�����8����:`���{X������
�&�o-0��W»pCG{p�v �,�����;��^O֛v��;�����	�����t\�|�#u�~�ľ)�cm� �Bt5'�3�Px�Bd2�n���6W)�	�ԝ SdԴj� E�����_b1u�B����G������y50:�FY=�Z����\c��_�����"?�-w}�!�������������?�m����z�Q�����q�&� �9����0q��W�y0�w(�b'v�CL�3�R���ݎ�Q{����������\t���X|��k�O���@���x�n\����_��tA
��+�� ��a�i�?+���Ϟ��$`:�9O��߰������\�����/ ���|��i��y���V ��70��GTR�.�-@�\�J���O@*e�ϫ��B�Q����%.��1=�C�jV��v&/��E�:���!W�܂7>�Cn��w��FG�SW�<��_*HW���Bi��XV����2�S?��7�0�ɢL���И��̃�e��F�#۠��Ots��n:BF��
���5V��L��˶���c��0���3�F��|�d�|�͜{���p�GM���XRq��]�w��`���[�pтTHJ�J��:K�g"�O*�ɼ����<��&s;YX2�#�!wMmRX")�)N�)Q"!���RY:;���N��JE�UKi�*���� Z��z�>,��=WW/���e+b���Ga�	ɗ��\1{���R~/-%kٙ�s�=4"3ɇ�3	�!&l/0�xR�bWW��W���H�Z9W=���ʥ|���Φ�4���Y��{���٫��]�QEؚ�w�>�����mB�^*@7��;��g�ohn��7E���iV���5,h����M�Ć������n�<~� �S�5o�W�n�j	5A(D���5 ������[�Ԡ�M������?�]�~�@,����E�V����/�n1����^Q@K�p(M�p�>�������\
���ð�?�,���4������������!?<t|E�RX�+�-a �#�D.c��@�ْn0�[�ߗ���F�F��-!x��
���5��<�J��c����>�.����)�������Z����&0{F�5�=\��.*�ȫQ��_��i����i6f�-��e��>�B,���K��l�q����>���bC��R�S�4�Dh���QKۄ38_B�Ѳ��C����b��?|�'��7���������e����d��a�a�y��Az�&~C�u)J1�H����ЃG1x;ȕ�|�^�0~xf�[0�S�q�?���⿺2���t��|d��*W���GT����l��(�q�9o�L�R�	v�.�����a��3>$Ï�x�p��	������$������6�	��:`���b�x
;��X�-��6��5�?_Sgԇo���������#��)���/0�`��;-�UX>!�-^�I$b�F�㹸y�1>�HDyE�B"�6�;��������߯�銷�[�F�I4MME�2D��n�����޶�|���R�n�������jk�Įӿ����.'��~��DE�����a��_����آF����(�ǖꠅ��筧(��	8���<?����|�Y�V�b�����?�l��z���?~�o�6�nv���&�s=���cX�o5�&J�4h� ���0�i�����=�A�\��|KV Z�t*�����6������"��e���x��b��N��i�$`K�;J��0�
����(Q�Qdv'.'l\�2�qԄ:��#�@$j[X��0$�l�RR����RbU"���B.�ʞ�R��j��\Rl��b�-���a3����qՐ��� �>����sFB��Rʣ�nVdkR�SH���R,'��:����;���kD߸�t�9k^�RM�Q��̾ו^�=��n�"[�zFU�&����{���i�Mڧ��1�iQ�p
U�+v����\��~G)�ʠx��
�S��c�vNҘQ�{��<�(ك��I�~t��o�K�Z@�{�J���-����`�T��B����E��^�q7'�O��s�m�q)�
I�`�����qّ���^��f%{��{�~��<E#�,d��_����R6���}�ɉɬ�sp�<b�݋J�P7��x�zrp|.8�4��r�Mr_�w��q�\k���AFnVTU(�O�� �S��sv�yX����0��W��|A��\ j�達�����b��~��[;�x.����{�����ԁ�K��Sٍ's��{�*练�ޯfq@N.�,&��T�V�[�q���D�-�Z*w��탣�{=%�mTO �#_&��D������s��ǵA=�O5#�\�"Č^�Ͱidɔ�ܠ�������za�Pf�a�O���b�,��ɒ���9l@_]]�#��/yCo�U�Sŵ�?��Sֻjl0,cbO@��3#�o�sޢ��(�Q��Wv���N����i������������I��\)p ��ԧT!��G:Y�MG'��@�6��Q�ar�|>y`����mĞR�%��Tط��=ִ��IC�|p�sn�\)Q,[��}T+��B�{��S�W�u��ҌW�~J��nmxT�BF�B���e�v�s��í�8�ɊI��a>�_e`&��zJ�5�l�{�?�<�??�����_<��w���<�<�?7G�����@P�ג�\*��3݁48���)�h�
I�GJ��-Jr|`I�tM�f�.��n�fᛶ)��O)��9��T���[��)':�!u�=8�w/����������I�z����b{o/���){�Q����h:,i���P^��������?�����xR�9�H�d.Y@���05�q�ʐ��f�z�c1�oCy�}���m��������C���T]�"�JVۦA�aK�U1e�pT�����!m����m|o��D�|�LR�|z�a+���|��C�(��n� �FOV�]��"��6����P!�X���xAjƀ� aQ�A��㟈B��F��7lG'�㯝�_ȣ�.����<�Q��o������ٻ�W���d�0tB����*4m�^&o���G��t��v{��l���0�v��=n�=����I�
�V�8qAB�	��8���!���=p����=��7���!�2Ϯ��Wտ�_U��*L~%������{��!�-��Z}|ӕ��2���gs!��fA	�B&"8+�0���㨧,W$)���S�m���#|�L"E�X��6:\:��h� �`2T!J���&�bB�������P�`V�6H�*t�շ�74�$ו��OH������BY>'M02��~Ѡ�d!ό�#�+�d �	nrPN1������c��&���|��|�Y��Y���_�;���>\�ؕ���~�������#�ϟ�]IĽ�XB�`���3�Oa{c����F�.�Uȭ�sr��c$h3E_ܛh������iCgP��S.��:]	�8�M�܉`n��\ӯ
�,��[Ʒ�	���$	L.I_ޟq�4����{�{z݀PH5��DqM	�Z�O"l"5F.�� <����E-�c �j�j[�sJE���ӑ���ĮmL��[���ҹ)�{B�1.��sg8:��|>��9���%�v�W�)}X+2M�dڵ�HU{c��`M��l�6�-��1D�A����1��>5�A[��3X!%���\���d�j�:QTD���˒��ˆ�a�kk>=����뚉�ޓ�k6�t��й���n��C2�'�TZ�*����s��G���9�����S��w��}�⚄"�J�n=3�S荁,c;E��16��"�ݍ�f}{������6$������S�X$�1�OF�ɯ����C����}����������O��7���?�˟�Ħ�z����!�C��m��M�X������ﾵ�+�6ڑ�Ϥ��Ͼ��z����x/.+�X2�ǥ^,��D��x/&SI9@RRbT,��g�$,�PzJ\NK��n�ß������d���=����o��?����Wf�"��#�_�������������t�����=\ဿ�p�?�@_�z���z�z��oa5ڎ#`�� c����آT���}K/f
J�<k�K1�z��U��K�1K�"n����UD `���S�/Զ����k.��(7%�g������tT8kυ�ZB8� ��p�j~!�yvIZ[��cQ�6�t���1�n�ǝaf!��Po�9?+p6%�.����ؗ��q7Z�	����q�#n���w��q�ݢl)ߜ��K��v^�yX����ڍ���7X�&�(�l3lz00���Qq���y?\
�\'a��y{lQK����X7uŢs�b�U/�$����ʳunϔ|���}P�	��͢f�#U�V34{5?�4�!��'��A۬�3�N�M#�ْc�Y-��jM�K?O��Z�Z�T������v߈'g5��X�ڣA�?>�o��:$Y�y5������Ŵ�
1Ϥ��r_+5��}uϚr�m/�JS5��O�n3��V�i���(M��RR�̭��+"G�zB��l�W���e�w�զ��/���/���/��b/��B/��"/��/���.���.���.���.�m��+�y�x�Q������D���k��"���nv"R�s����r'�׳��E��?q;+	�-9?_�����(Q(�o�z�{n�z�vV@ ���;�p;�Cx���[V��Q��O��9-�w�r��R����-�Y�72�Bt KrԌ
'EZ;'"Z�O�sM��m]�TO&T���%j������q?��A���t&D�ɕg˓J���
�ϖ6�M�|Ҏ�k����Df�L�"�\.�T�a<�&��4Y;7j�Ԍ�HĬb�J�<}RJ�3V/Q��W���d�ӬL�UB��X��z��,�rWhٮ�7k/�ڿ���/��z�	��}c�ݷ�n.7���v�ݰD��[v��Ʊ/��Yg#\�����j�Zw�4���7B;��Ga7_�}ev)]�`�[~�B�ؖ7Co�^�pY�Џ����o<
���D�=W����Gn��B�� ��s��gך���2�|>o�g�Ԙ*�Z��T�$)��|>_��ϱt������w�cXX�N �ǖ��M�,@��Y.�6Qs�r��ٜ�.�ڴ�'��,p�`�B��%�"�v]g�3+�!0�� ���f5
5fI�
�i2�,�㪒;��d5ޚə!U�#��.�k�H����I:;���9��ּ��t��<抪Ə�������8V&�}<vˠ�Y$�ͨm}�Y���Fƴ�XdV�iL��jV5����g��S)�sh����k�ͷK��Xs�j�@�Gk�v�,Փ�D���pxLED�$�T`�FR�fM�K� D��>��5�G���H��ue�3�Z�Y1���O|�?�*���k�&�e��k�b��Ú0-��t�b��~}y���_��o
����f��[��^���}�?�V1�V�b�^�ϸE�,ʺ�x'�����3��;q[}�ԝ�1��v���@j��Z�f.�N!����L�L���Z3��R5�Λ�|�ak�QC)�����Vk���27`�S/)VǮ;
N��k|����� �)��F��\8s�Wh���@�s�@����,gL�f����s!a��j�Ws��L�{��T�~�tBW%�L�?V���p�U7 �z����uO�U%�9V���@l�c��H͊����w�0��E�0*+���B�7�4�Kѽ�ha[\#ӧ����Z�H��g/�յ:Q�#Y��P�k�щ��
T�)�}.D%�ľZGb�y�u$�?��m�`����	q�%ϙ�8�Jg�t�s&u�{��y�w(��(Vkw���}3�7�QM�!��p��`�eM�׊�g�Z�W��r_S@�3�v9�`�UN�ͦq����ez:ӈ��?A���<���j���yl�����6P��9�kjq.��gJt�e'� ą��ay}��D�%��f(5^LԤ��J��-�#�''�y����M(��؇3LFk�c7���%[`�s���t�0�b��meV�pW)���V����G0�ĥ��	�n�B^�{�BQ?ؼq?��x�V�/:g���I�5�|��L<pcպbZ�yq��3�
�h�W�SS\�������7MC7�,{���:�R	=��C���_R~�%��aoŭG=�x�y�qPD �ǋ7���|F�ǠW&�@�d������|��x� ̾6Ri]5`�����k2��>%~�f����s:�����y���ﻃC��D1M�%B�ć.�)�6�u�\�q�#�se�x����ϭ?�x���D��f�_����_$�p�C<���ϯ�s?�_�>~�\?��4��zJ�Z���s'אn�)w&aH
��c�e�3���0�t�a2&Lr&`�X�PY�DHO�UA�U����ݝyH.�	k�k`��k�յin�*}��C�3�	�*̵� �t�,����j��xͺ^���֋$��ѯ�r�$�r���[�������[�6�����@����˸D�:�"�=t�=!� �ajP�'
.ԅڀ=�]	��Q�`���A|���H.�Sӻ���Y�M'$�[��7��L��P��˥�a헧����� ��z�B�al�k��p�{�'[T�cҕ�`sQ�����eo�z�:^�@Šޙ�c\D�Y�����,2]�Lq1 �+��Y��$���öb��\2V��{���W�&;>1��!��i(l�-_	C8j���8� �"tb��Ɣ��$�2(0�N�QW�����s�$�T��9�Ⱦ�z �;�Ə�M�o"lo�z����gu��m;ذ���:o�æ�#~=�"��+Jx��0M|ֳ
�hc|l�t��h>��Ŧb�4Zc�"ZW����p�Fb���p,��Fʡ̭5j���"rؼ�p�BR�3����pY���Wۀ��5.�oD�7�c����$��G&p�Ll�a�Һ[�&�������~��)���w���p�I�r��8�"$���x�/0���Pπ�;�1`I���0�wo z��N�*�P�n����Y��\��A�k%N{��<�сɨ�6��PRz���F.�*��\ɨ�N���8kdM�� _a��R��,x�W�1�5����bf�`���m@�ce2�]A��@�qs��B�k�%��)���ZfaA&;���/�+�\�{�v��A�l�2р�%���j���ĹU��݊3iR`�����ml�h�����G�^2�&�Xo:Nǌ{�(���1
*T� �5"k�v����wvŐ%�\�!=9��L�r���fb��yH�y�{ +���Q�f�P�"r�M��Ct;4��&^]f�����9�a&���,Eps�yM4��E�Y�8FSv'���|"�����m7�7f)�mL��X��_�q�p?�j\8�W��3D�m3���`_o8�j����.މsm���O����%⑯��z%4�X!>�~JH���l�sñ����Ûޓ�Jf=���9�����,}���xV�nx+MW0�lp�c����iHbK����*�^����*_M]��?E����k*:��/V�FeЋ%�R )��D��)�D/��u�J��S=
����g��ԓz�$���
�&��9p��}��{����^�C�>��K~��'�%��U|qȍ{�e@|�94���HR %@��H<I�@��J� @2�(�H:�Vb@��= 9��(�B�$P cȧ�s	�!�;�ɧ�3�� ��/<����M{��{�٩�Yn�Ì�&[�o�x��^z�ॺ[��\�v�+su�tZ��K�1Wz&+�T�<��2Ͳu��x�qV������8�Pa��E�k�n�1o���kWt*K��F�g�ʮˍЄ�9�V��
"�<?����h�&l���j���9�U��O%,Pl]s��*�h;�<:3�-����EY�ص�����[�1�b����o_*�.�W,�\.����T賕:�$=ϗ�U��oH;~�-�|9[aW9�`9��_�z,�re�Z����H���a��:<��d:rC�3(��$���啋I����]�R�Ҵ�6��=�E�����s|��̉�J�H��{�����we�ikK�]��S��y��N���@Hb��)M�y ����81$v�xk��׃�!������ݫ���������y�O�>����oo�n��ƹ��_��Eе��gWv�����ʊ����I����-O�i��{z����4H��D��ޥ_l\�쨗G����][(��,��}L}�H��c�d߻��\D���5�ƛ��Y? �7�הm��Ew�^��;_�jor�c��u��q�Jq���y��ܗ�{�4.��t��߿��c�����;�����;ܤ)�x���u^ջ�Py�\�H�\��۰�����6��e����_��x�������7��x��?���;��}�o��=�Ϝ���G,��9�����o���;ˢ�=cC�b����<��8�?M�/��X�@��ׯ�?(�c��@��?8��8����G��������3E��?,�wg��?$@���X
�Q�0!Er(�1u��"�p�pQ�$�T��")���&X1	�8�X:���>�����!�gx�V���/$�J������?�a�?^lǋ��+�jk��u��r������w-�=Ȓ���׃��I�l�������\���[xLB7�3��:�v�'z�	5j���!����SL6i���jj�!�d��u�*ϴ����w����������"���'�>P��{��� ����i�N���GT���"������?�������
��KIv����?���^���$����]��B ���?��������� ^���T��*��Q�'K�7�O�p��0��t�u	�/�Gݩ���$�@�E����ϭ������0��- 8��u��IS���k�}������O��F�蕶��TK�l���m�穐���T�O����������c�Y3���yi�$�����Շ���������ILm���&N�Y�85�Ge7ףr���>����`�5������e�d+WZu�ש��!1:U*�ޡ��>�v<��Dn������I�L�g5���B��5z��\y��_��ђ����_���t8Z����}��ͤ<�&[e詹%�8�N�q��7�tŪYi�S��KU�ڟE����m;ru!��UȻ��v�i���	{h���)�iI,����ߵAR � ��ϭ���8�/x�?�D����'�#�?���?��S����G��C�_6N���(@������pm|���?
`�����������ë���9����@��|���<�hسq����|�_�~���C\���~�{4����k���v�[	%}�#�%�aG���:�����p:�*�K6�:o�+)��R�6�HsJ=I��X�z��m�M�"#����e��5�'���ٔ�k\�?���,獇�~��vn,�o��s���;�_ر���`�t�DF���>��E�-��`45�F��*W�J:�Xn���wG��*JW<���Kݒ��,6$��sҲkv������/�B�Qw��0���m���� ����8�?��Z����?����0��h�QqD�T̉\Ȋ�IR��	��Eb1<�BD3aD2q�ĄdB������4����٩�7&���l�+e�'�e&�7'鰚�R���I��Ӱ�>��ۢ;�=��C}��r��7����Q�JFM3���>Z,G����F��,�ǚ�5�d��,�pUN����-:#�k���V����gq(x����ԷP��C�W����)�����u��0>!p�������v�����^�/z��:���yy%�޴�ѣ���'�$�r���M�o�]5m��B`3�.��z5`N�1̝q���%�)�I3��/5�딎�\�w%���s>Ϣv��e������ �{+���i����(�+������8�A�Wq��/����/�����b�?�� �On�À�C����:뿔��o�춪�A�����A���~���ǓB��Or���_Yt2⬶F�2��>�3 ����� g�U��h"�U��e��3 d{?\��!�K��i��zJN�͐h�*e�Qύfe1q�SUO]J�N�)4���Ϊ��Q��՛��H�v1��~��o��w���-\|���W�� ������9�(�^Q�ⓐ'oТ�VN�vbU�]EE����4'RC�~�qZ��z��TӇ��JI�,���7��KM���x����H6u[5�n�llv�JY�w�S���FM�C�h.�%?\���*����X�$R9q�-��2�<�Ηf��m�fO�ӃbQ��q��롌w���b��?�
|��P�/P��k��m��5����&��@�? �������g��/�? ��x��?����?����DA�A@��()y.ÐdER����6")�g�D E^L� �/� ��cQJX!�>H���ÀC������$����~+�MO������7�nWV���#k�eO�e�K�K����W��>:Ή��˅Q��ݺ&�Ky�X�����M�E���n�{�.O�;S|}�wv5��h��ۨ�W�M�d���}+p��)����� �������w	�P��;��<CC����&�������x>�w��_4���M���9�˗o���� ����;#@�^����F�s���k-�V����q��K}:�o꿣S!�ߚ<��5"~�����+�ߗ�l⇵�y޳{�m����'ՊO�Z�]݉��bS���q���x��M�-���^ǭ+�Es��
��7�Q	bg<�L��U���#��;����j�7&��4M����\�������T{C9�2���NPE"6��4o�׫��DF�jmH�c���� ��Ve���{�a�lְyB��u�VNדʣ�_4�K�E�˻�^�˩�:\�_έ�1^V��*Ѝܔ��C��f����J�>����uY62���j��4���
��?��Á�i��ׂ����7��߫�f��	��꿡���������,� ����s�?����r��~Y \�E����� �G���_����b�������P����]v��E�O�}�X����,��H���$y�3��(�����öP4��������]
�0�(������?u���?`��`Q ����������@���!P�����H ��� ����_�����B�"`���3�@@�������� �#F�m! ������H ��� ��� ����
�`Q  ����������9j`���`��	�����������?�D�_6N���(@������pm|��0�	��(�G���/P���P����	X�?���@�� �o���r�@�_  �����g^\0�p��:���L>�� 2�8�d��I,�$��b�ÒQ@�B ��R����O�QW����)���W��ct����)�������T��yp��vJ�F�l*��,��!O�-�K:T?����l?�hIt�4��udK���f�f�guV�7=UU(���\�-Ka�lw��w�*���5�:N�Qo�-�;�E't�e���Z�%�y�����>�v7o��3����gq(x����ԷP��C�W����)�����u��0>!p��������cr�Ҷ��Ң�"���0Qk�v|�T�?Y�ڇ�Q^��1�s����93�Tf[%��lFF<��4{����[F��C�X���N	7��i4X��6�v��W�$'����֋I{�s�o����w��"��m����� 꿠��8@��A��A��_��ЀE �w�����A�}<^����_���S��.����p�v6ًJj��p�W�~��{�vi�)��W�U8����x�1�����ܨ\��SiͳNm�
S�F�D����بeq�q{��L{<���^#ꤍ	?�O���2�e�͔_�'��r+3�˜��v���x�]�N����^E�M�|-l�T�(�N��&�j�@��Z9MۉU�w-��vSO��<5D���-�ie�5��f�H6u[5j�!�֒f��4��!3cc��]b~h����I�js�7�bt�1C-�f�4�8�ζ�X��e����R�[3��p�ℵ����+�����������5�z�˳�_jAR`H8�E��X���ߺ�_����H�C�G�w�?��	>���:�A��@��?��,I���8�?MR��,�?
���_O�����������ߙ�y����k�?�UU9>>���~n����3)Iiƣ�1oN��P���Mv��?T��a�2�>dܴ�z:+���aV�kʏx�܏����s=}<�ͷ/S����O���%uy�\^\K��mKz��*i��i5�笫�(���Ω/��FuU����։6ט�溴ѫ�t���<���޷#��S�]Q�L���U�m�����-��*3;����O�͒�+��h�k*�}Oǹ���J:�/�˚�~J��'���Z�T��D���XQ�k�5SR���	�������͕&	}��1X���2�VM�]+��9vD�J�:g����ݞ�r�/��~N�3�K��SJ�T{�@ɝÀ��07���O���5vvt}?�INK���?7��,�wS�翈�F�	!G�<��0)��!Q��a���!���8����#�|�EdJT��Cg�G����������	~g��ƧC��owF{�B���x3��u0�%�Cȷ9c�#_I��o���j�x�\����+>���$�q��Q��P �G	̭��� ��!�1P����?�����������K�/x��[q�r���VzGK:}>F7���E�������YQl�~�W��*^�_^���# �y::2 �TE����p�f�L��[Y�@�{Ed��(묽��X|	�b����:ؐ����?��!������7��fmn|��u�~���y�߯_q�a�ϝq���i�V�u�g��>R�{���\�\��u1Y�7ʎ��N��i�w5C})������<sE�rd_��n?�k�~W�r��j��u8�vlJe~Rf�H��;V����\n�)+��g��������8�{3I�G��u'862f��u��(��z�H39k[�n|,��M�9ϰɍQ^��T^)$����N2c�|��E�Ľ�������J�n��*�U�*A�+~:����05�Rq��V�d��h�e����d^�U�������������[�����n�EJm{#�X�ƦY>��0��qW����������}ْ��ke��ފ����~����Tp��e�"�D���?�_���W��_��XH �����P�+?d���2�Td���������&������>���T��n��o��j�Z{{p[������mN��h}��Q<��k�Ǻ۱�E�D9���J�>?uV©S_�:�m�M�l��OVB�r�|���u�
yn]�b�/����Z�n�}�m%���u�J�ZF�3{��R7�V��K�hߙ,�}��Z^O���7�gq]'n�2�E<p5���]_�^��Wkt�a��|�鴅�N	/�m����p��ȷY6n^�}Vߏ�-kM�c��Z�)[b�x�6��L�]���n!7������M��ar�A_�ٶ�o�jϐCiLף���!sP�bʱ��m�qF��Z�Y�����,0��{�8�5_+�#�Om���G.��Q������?� ��_W��/*��l�W���O�!K��@����m�'S���L ��	��	���������.�B����E�X���?�+
a���K���3���oP��A�w��c��t���.��,��?o����٠�������!��	���  ��ϟ������7����_0�{ �����~���2B��u!��?���O�����g���?ԅ�	Y�����@bP�!@��� �����/�d�<�$����[���+7� �##��!#$?�������?��P��?@��� ������P"����������� �u!rB!����	���&��P��?@��|�������L�����s�����
������	�����
a�C�n��������E!�F��ON�S���Sm��� ��c�"������CF(��4���U�%��5�`�f���MuiV��a0U�IZ7M��&{(��jS�1�z~����"�����!�?���{y��E��0���R���͵%�m���-����Xhp��o�߷h����_���i�ϑ@��*���SS��5���n��l�\=j{f�C'e>.en7����R�]���o,;��@U�����~����=NZx����|֪��InvG�5V�磽wsSyx�P���懼��h��E@����C���C�������{E����÷��8�j�^�):�0$f�带�4�X�f��}$���|x����d�]v������v��D��g#���=�G89l*U��3�FEGwMs�TTN�V�HZ/w+e�Kb-��C�\�`��Ř�+���	y�����?���P��/������_���_������4`�(�����G������=��G���XQ ���Ufy�H7d�N���o��>^b�����ښ�Lr�ϝm�ko��,���}
è�p��vc����d�ռY��r�qZ���cB�\"��֯%�l+��^SĮ�Q�~E���z5l�%4WZ�۵Y��.���W)"�:�|�rñp����������4�x�q�q#����]��8}rys[P�c�Q�|�+�''�Od���������.�f�P�n-������l�:r��	<"��S9�M��;�vuL��	�I�#M�]]��n㨲����^�����S^������QPd��i�������
��̝�/�?d��//^���9! �����v��)�������� <8����s��N��2A����	x�c� ��ϝ��;���	���P2{d����c���P��?B���E!�~���/���d� ����_!��?���?��������_�?2��?�i���1�C����(t�7=uf0���~��������c����SϹib�u����܏�Ð�����~ o������5��{����7�����+N4l��3.6�=��J���q�Gjt���˚�w�.&k�F�q���i�:��f�/��qA�a՜�g��X��+�4��ڼ�k�/r'�WՄ��p,j9�ؔ����0�*mw�lO��8��SV���l����:3���$�cם��Ș1�z�����Q���8֑frֶ���Xد�8js�a���8x���RHT�ۛ!�d�^?�à���sC���U�����c�B�?���"���K�d�B��w����	������_P�+_�����������<�xH�������Oa��9�@��p |o�������%��^O��_�Tv�m�aG����D�X��l�C����7_��cɺ�':�ltwr��)�Q ��Ǉ��!܉��) {^S%�fU��:J3[EY��-���4�24B��ö��O�<����F	]<6*t���C}U��ք�� $M�+9 H��G9 ����lM���]|�������!ў�,w�$$ʶ�^�մ>/sTXs;�p�4"w(��ʽ���qHM�5s��;�f{?���(�������_� w���	x�#� ����_���ߩ�X�����F2�ZaL�Vu�VU�e���4��p�0	��
�MLe0ӤtCch�Ve�%M�����GF��^�O���߲��Y0C���Zk��32�����j2��Š��kјG����|���y�ʺ�B[��{k�� Қ�c۷*��9�
}�:Dyu���9J�y9m��x&�f�҉|�a�~4���oE����r���&Py����?�����?�!w�i���y�C���_~����?�o��J�z�¡K��kR����7�"�C����N��]�?zȟ��x�#|߯����#7(��B��4&��L�A������V�+Fԕ4��|��6��?��&4gG�$��{+�1���Q	��}��Uh �#
��_�� �� ��?�������E�U�������������e�>=�=%��j�w�w����/9 �R�}] rm�:���½��h���2�0~Y1�3<m����mј�:x"�j���E��N4=�#ۭt�rml�)����P�xuQ���f�s��2Iu��q�����{�������>�Pb�c������Ƚ����Qk���UɋƚRd^C�X��V�p�Ҕ��sX�(�78>���<J~4��L������ˍ�V�"�Y�@��#N��v�4��/�<3�Ξ��h�����8ȗ��e�{h�����:�kQ˦�� 4'�bk����/�sr�W�5�o'�4���8�j{g�|��o�������O�� i������2�R����(�{��y�t�:�n¨GD%��2����=v����޴�\���������t6F���t/RAJ>&t�һ�>�������Ӈ��;��IKw��y[�<cs=��l_�T�lL~���k�^��~�R��;����D����s���?��?�	c�����Ts<TSCA�Q�NT�z%�	¨d�6�w�/*��M�ĸ����ЈJ�C�)P�Rd%}Fr��	=�'�.~�����e)�/�ᩮ����c�����x�����o?����?�Y��e�*9+���_���Ӈ�A�	)���eC�y{��1O'wSZnc�k߻�K��}�j26�6(5N�l��e��#Q����'$9��t59�ּ_X�턼���9�U�$|���0��OIu8b��#�-tǣ_�{��'y{W3��A�ޖ~��ޱ�!��0��ݛ\݅$/_��]�9�C/��`O���_�ϛ�Ǘ��)�mKwl��b0
KH�srM�5"�?ze�{D�^��u�߻�d�_���'w�.���݁�'���a��vDYz��n."MB؇)�]�~�I�?�i`V���>����,�E?=�OO9�    �X��d�� � 
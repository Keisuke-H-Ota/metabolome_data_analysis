# MetaboanalystR を用いたメタボロームデータ解析
# 参照 https://qiita.com/keisuke-ota/items/803c4299138b169eb9a2

import os
import streamlit as st
import altair as alt
import pandas as pd

# MetaboanalystR の解析結果を取得

cwd = os.getcwd()
path = ['results.csv']
file = os.path.join(cwd, *path)
df = pd.read_table(file, sep=',' ,header=0)

# 散布図の x 軸、y 軸をリスト化

axis_list = ['FC', 'Q_value', 'VIP', 'RF_MDA']

# リストの中から軸の種類を選択

x_axis = st.selectbox('Select x axis',  axis_list)
y_axis = st.selectbox('Select y axis',  axis_list)

# Metabolites 欠損地処理方法、標準化方法を pd.Series 化

metabo_list = sorted(set(list(df['metabolites'])))
RemoveMissingPercent_list = sorted(set(list(df['RemoveMissingPercent'])))
Normalization_method_list = sorted(set(list(df['Normalization_method'])))

# 可視化したい metabolites 、欠損値パラメータ、標準化方法を pd.Series から選択

metabolites = st.multiselect('Select metabolites',metabo_list)
RemoveMissingPercent = st.multiselect('Select RemoveMissingPercent', RemoveMissingPercent_list)
Normalization_method = st.multiselect('Select normalization method', Normalization_method_list)

# 選択しなかった場合は全データを可視化

if not metabolites:
	metabolites = metabo_list
else:
	pass

if not RemoveMissingPercent:
	RemoveMissingPercent = RemoveMissingPercent_list
else:
	pass

if not Normalization_method:
	Normalization_method = Normalization_method_list
else:
	pass

df = df[(df['metabolites'].isin(metabolites))&
        (df['RemoveMissingPercent'].isin(RemoveMissingPercent))&
        (df['Normalization_method'].isin(Normalization_method))] 

# 散布図を作成
# 各プロットは代謝物に対応している。

plot = alt.Chart(df).mark_circle(size=40).encode(
    x=alt.X(x_axis,axis=alt.Axis(labelFontSize=15, ticks=True, titleFontSize=18, labelAngle=0)),
    y=alt.X(y_axis,axis=alt.Axis(labelFontSize=15, ticks=True, titleFontSize=18, labelAngle=0)),
    tooltip=[x_axis,y_axis,'metabolites'],
    color='Normalization_method',
    opacity='RemoveMissingPercent'
).properties(
    width=700,
    height=500
).interactive()

# ブラウザに表示

st.write(plot)